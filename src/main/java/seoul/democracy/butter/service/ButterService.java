package seoul.democracy.butter.service;

import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.butter.domain.Butter;
import seoul.democracy.butter.dto.ButterCreateDto;
import seoul.democracy.butter.dto.ButterDto;
import seoul.democracy.butter.dto.ButterUpdateDto;
import seoul.democracy.butter.repository.ButterRepository;
import seoul.democracy.issue.domain.IssueGroup;
import seoul.democracy.issue.service.CategoryService;
import seoul.democracy.issue.service.IssueService;
import seoul.democracy.issue.service.IssueTagService;

import java.time.LocalDate;

@Slf4j
@Service
@Transactional(readOnly = true)
public class ButterService {

    private final ButterRepository butterRepository;
    private final CategoryService categoryService;
    private final IssueService issueService;
    private final IssueTagService issueTagService;

    @Autowired
    public ButterService(ButterRepository butterRepository, CategoryService categoryService,
            IssueService issueService, IssueTagService issueTagService) {
        this.butterRepository = butterRepository;
        this.categoryService = categoryService;
        this.issueService = issueService;
        this.issueTagService = issueTagService;
    }

    public ButterDto getButter(Predicate predicate, Expression<ButterDto> projection, boolean withFiles,
            boolean withRelations) {
        return butterRepository.findOne(predicate, projection, withFiles, withRelations);
    }

    public Page<ButterDto> getButters(Predicate predicate, Pageable pageable, Expression<ButterDto> projection) {
        return butterRepository.findAll(predicate, pageable, projection);
    }

    /**
     * 버터문서 등록
     */
    @Transactional
    public Butter create(IssueGroup group, ButterCreateDto createDto) {
        Butter butter = Butter.create(group, createDto);
        butter = butterRepository.save(butter);
        issueTagService.changeIssueTags(butter.getId(), createDto.getIssueTagNames()); // 태그저장
        // 메이커 저장
        // ButterMaker makers = butter.createMakers(createDto.getMakerIds());
        // butterMakerRepository.save(makers);
        return butter;
    }

    /**
     * 버터문서 수정
     */
    @Transactional
    public Butter update(ButterUpdateDto updateDto) {
        issueService.validateRelations(updateDto.getRelations());

        Butter butter = butterRepository.findOne(updateDto.getId());
        if (butter == null)
            throw new NotFoundException("해당 토론을 찾을 수 없습니다.");

        return butter.update(updateDto, categoryService.getCategory(updateDto.getCategory()));
    }

}
