package seoul.democracy.salon.service;

import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import seoul.democracy.common.exception.AlreadyExistsException;
import seoul.democracy.common.exception.BadRequestException;
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.issue.domain.Category;
import seoul.democracy.issue.domain.IssueLike;
import seoul.democracy.issue.predicate.IssueLikePredicate;
import seoul.democracy.issue.repository.IssueLikeRepository;
import seoul.democracy.issue.repository.IssueStatsRepository;
import seoul.democracy.issue.service.CategoryService;
import seoul.democracy.issue.service.IssueTagService;
import seoul.democracy.salon.domain.Salon;
import seoul.democracy.salon.dto.*;
import seoul.democracy.salon.repository.SalonRepository;
import seoul.democracy.user.domain.User;
import seoul.democracy.user.utils.UserUtils;

import static seoul.democracy.issue.predicate.IssueLikePredicate.equalUserIdAndIssueId;

import java.util.List;

@Service
@Transactional(readOnly = true)
public class SalonService {

    private final SalonRepository salonRepository;
    private final IssueLikeRepository likeRepository;
    private final IssueStatsRepository statsRepository;
    private final IssueTagService issueTagService;
    private final CategoryService categoryService;

    @Autowired
    public SalonService(SalonRepository salonRepository, IssueLikeRepository likeRepository,
            IssueStatsRepository statsRepository, IssueTagService issueTagService, CategoryService categoryService) {
        this.salonRepository = salonRepository;
        this.likeRepository = likeRepository;
        this.statsRepository = statsRepository;
        this.issueTagService = issueTagService;
        this.categoryService = categoryService;
    }

    public SalonDto getSalonSiteDetail(Predicate predicate, Expression<SalonDto> projection) {
        boolean withIssueTags = true;
        SalonDto salon = salonRepository.findOne(predicate, projection, withIssueTags);

        if (salon == null)
            return null;

        Long userId = UserUtils.getUserId();
        if (userId == null)
            return salon;

        salon.setLiked(likeRepository.exists(IssueLikePredicate.equalUserIdAndIssueId(userId, salon.getId())));

        return salon;
    }

    public SalonDto getSalon(Predicate predicate, Expression<SalonDto> projection) {
        boolean withIssueTags = false;
        return salonRepository.findOne(predicate, projection, withIssueTags);
    }

    public SalonDto getSalonWithIssueTags(Predicate predicate, Expression<SalonDto> projection) {
        boolean withIssueTags = true;
        return salonRepository.findOne(predicate, projection, withIssueTags);
    }

    public Page<SalonDto> getSalons(Predicate predicate, Pageable pageable, Expression<SalonDto> projection) {
        boolean withIssueTags = false;
        return salonRepository.findAll(predicate, pageable, projection, withIssueTags);
    }

    public Page<SalonDto> getSalonsWithIssueTags(Predicate predicate, Pageable pageable,
            Expression<SalonDto> projection) {
        boolean withIssueTags = true;
        return salonRepository.findAll(predicate, pageable, projection, withIssueTags);
    }

    public List<SalonDto> getSalonsWithIssueTags(Predicate predicate, Expression<SalonDto> projection) {
        return salonRepository.findAll(predicate, projection);
    }

    private Salon getSalon(Long salonId) {
        Salon salon = salonRepository.findOne(salonId);
        if (salon == null)
            throw new NotFoundException("해당 제안을 찾을 수 없습니다.");

        return salon;
    }

    /**
     * 제안 등록
     */
    @Transactional
    public Salon create(SalonCreateDto createDto) {
        Salon salon = Salon.create(createDto);
        Category category = categoryService.getCategory(createDto.getCategory());
        salon.updateCategory(category);
        salon = salonRepository.save(salon);
        issueTagService.changeIssueTags(salon.getId(), createDto.getIssueTagNames());
        return salon;
    }

    /**
     * 제안 수정
     */
    @Transactional
    @PostAuthorize("returnObject.createdById == authentication.principal.user.id || returnObject.createdBy == authentication.principal.user")
    public Salon update(SalonUpdateDto updateDto) {
        Salon salon = getSalon(updateDto.getId());
        if (salon.getCategory() == null || !updateDto.getCategory().equals(salon.getCategory().getName())) {
            Category category = categoryService.getCategory(updateDto.getCategory());
            salon.updateCategory(category);
        }

        issueTagService.changeIssueTags(salon.getId(), updateDto.getIssueTagNames());

        return salon.update(updateDto);
    }

    /**
     * 제안 삭제
     */
    @Transactional
    @PostAuthorize("returnObject.createdById == authentication.principal.user.id || returnObject.createdBy == authentication.principal.user")
    public Salon delete(Long salonId) {
        Salon salon = getSalon(salonId);
        return salon.delete();
    }

    /**
     * 제안 블럭
     */
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public Salon closed(Long salonId) {
        Salon salon = getSalon(salonId);
        return salon.block();
    }

    /**
     * 제안 공개
     */
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public Salon open(Long salonId) {
        Salon salon = getSalon(salonId);
        return salon.open();
    }

    /**
     * 공감
     */
    @Transactional
    public IssueLike selectLike(Long issueId) {
        User user = UserUtils.getLoginUser();
        if (likeRepository.exists(IssueLikePredicate.equalUserIdAndIssueId(user.getId(), issueId)))
            throw new AlreadyExistsException("이미 공감하였습니다.");

        Salon salon = getSalon(issueId);

        statsRepository.selectLikeProposal(salon.getStatsId());

        IssueLike like = salon.createLike(user);
        likeRepository.save(like);

        return like;
    }

    /**
     * 공감 해제
     */
    @Transactional
    public IssueLike deselectLike(Long issueId) {
        User user = UserUtils.getLoginUser();

        IssueLike like = likeRepository.findOne(equalUserIdAndIssueId(user.getId(), issueId));
        if (like == null)
            throw new BadRequestException("like", "error.like", "공감 상태가 아닙니다.");

        Salon salon = getSalon(issueId);
        statsRepository.deselectLikeProposal(salon.getStatsId());

        salon.deleteLike();
        likeRepository.delete(like);

        return like;
    }

    /**
     * 공유
     */
    @Transactional
    public void shared(Long issueId) {
        Salon salon = getSalon(issueId);
        statsRepository.increaseNoOpinion(salon.getStatsId()); // 공유횟수 증가
    }
}
