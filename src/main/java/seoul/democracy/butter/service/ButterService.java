package seoul.democracy.butter.service;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import seoul.democracy.butter.domain.Butter;
import seoul.democracy.butter.dto.ButterCreateDto;
import seoul.democracy.butter.dto.ButterDto;
import seoul.democracy.butter.dto.ButterUpdateDto;
import seoul.democracy.butter.predicate.ButterPredicate;
import seoul.democracy.butter.repository.ButterRepository;
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.history.repository.IssueHistoryRepository;
import seoul.democracy.issue.repository.IssueStatsRepository;
import seoul.democracy.issue.service.IssueTagService;
import seoul.democracy.user.domain.User;
import seoul.democracy.user.repository.UserRepository;
import seoul.democracy.user.utils.UserUtils;

@Slf4j
@Service
@Transactional(readOnly = true)
public class ButterService {

    @Autowired
    private ButterRepository butterRepository;
    @Autowired
    private IssueHistoryRepository issueHistoryRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private IssueTagService issueTagService;
    @Autowired
    private IssueStatsRepository statsRepository;

    public ButterDto getButter(Predicate predicate, Expression<ButterDto> projection) {
        return butterRepository.findOne(predicate, projection);
    }

    public List<ButterDto> getButters(Predicate predicate, Expression<ButterDto> projection) {
        return butterRepository.findAll(predicate, projection);
    }

    public List<ButterDto> getButters(Expression<ButterDto> projection) {
        Predicate predicate = ButterPredicate.predicateForSiteList();
        return butterRepository.findAll(predicate, projection);
    }

    public List<ButterDto> getButtersMine(Expression<ButterDto> projection) {
        Predicate predicate = ButterPredicate.predicateForSiteListMine();
        return butterRepository.findMine(predicate, projection);
    }

    /**
     * 버터문서 등록
     */
    @Transactional
    public Butter create(ButterCreateDto dto) {
        Butter butter = Butter.create(dto);
        Long[] makerIds = dto.getMakerIds();
        if (makerIds != null && makerIds.length > 0) {
            for (Long id : makerIds) {
                User user = userRepository.findOne(id);
                butter.addMaker(user);
            }
        }
        /** 아무도 없으면 문서를 만든 사람을 넣는다 */
        else {
            butter.addMaker(UserUtils.getLoginUser());
        }
        butter = butterRepository.save(butter);
        issueHistoryRepository.save(butter.createHistory(butter.getContent(), dto.getExcerpt()));
        statsRepository.increaseYesOpinion(butter.getId()); // 버터 추가횟수 증가
        issueTagService.changeIssueTags(butter.getId(), dto.getIssueTagNames());
        return butter;
    }

    /**
     * 버터문서 수정
     */
    @Transactional
    public Butter update(ButterUpdateDto dto) {
        Butter butter = butterRepository.findOne(dto.getId());
        if (butter == null)
            throw new NotFoundException("해당 토론을 찾을 수 없습니다.");

        Boolean wasMaker = butter.getButterMakers().stream().anyMatch(u -> u.getId().equals(UserUtils.getUserId()));
        if (wasMaker) {
            issueTagService.changeIssueTags(butter.getId(), dto.getIssueTagNames());
            changeMakers(butter, dto.getMakerIds());
        }
        issueHistoryRepository.save(butter.createHistory(dto.getContent(), dto.getExcerpt()));
        statsRepository.increaseYesOpinion(butter.getId()); // 수정횟수 증가
        return butter.update(dto, wasMaker);
    }

    /**
     * 메이커 업데이트
     */
    @Transactional
    public void changeMakers(Butter butter, final Long[] ids) {
        if (ids == null || ids.length == 0) {
            butter.removeAllMaker();
            butter.addMaker(UserUtils.getLoginUser());
            return;
        }
        for (Long id : ids) {
            User user = userRepository.findOne(id);
            butter.addMaker(user);
        }

        List<User> removedMakers = butter.getButterMakers().stream()
                .filter(m -> !Arrays.stream(ids).anyMatch(m.getId()::equals)).collect(Collectors.toList());
        for (User removedMaker : removedMakers) {
            butter.removeMaker(removedMaker);
        }
        butterRepository.save(butter);
    }

}
