package seoul.democracy.issue.service;

import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import seoul.democracy.common.exception.BadRequestException;
import seoul.democracy.issue.domain.Issue;
import seoul.democracy.issue.dto.IssueDto;
import seoul.democracy.issue.repository.IssueRepository;
import seoul.democracy.issue.repository.IssueStatsRepository;

import java.util.List;

import static seoul.democracy.issue.predicate.IssuePredicate.equalIdIn;

@Service
@Transactional(readOnly = true)
public class IssueService {

    private final IssueRepository issueRepository;
    private final IssueStatsRepository statsRepository;

    @Autowired
    public IssueService(IssueRepository issueRepository, IssueStatsRepository statsRepository) {
        this.issueRepository = issueRepository;
        this.statsRepository = statsRepository;
    }

    public List<IssueDto> getIssues(Predicate predicate, Expression<IssueDto> projection) {
        return issueRepository.findAll(predicate, projection);
    }

    public void validateRelations(List<Long> relations) {
        if (!CollectionUtils.isEmpty(relations) && issueRepository.count(equalIdIn(relations)) != relations.size())
            throw new BadRequestException("relations", "error.relations", "연관 항목을 확인해 주세요.");
    }

    @Transactional
    public void increaseViewCount(Long statsId) {
        statsRepository.increaseViewCount(statsId);
    }

    @Transactional
    public void increaseLikeCount(Long statsId) {
        statsRepository.selectLikeProposal(statsId);
    }

    /**
     * 제안 블럭
     */
    @Transactional
    @PreAuthorize("hasRole('ADMIN') or hasRole('ROLE_MANAGER')")
    public Issue closed(Long id) {
        Issue issue = issueRepository.getOne(id);
        return issue.block();
    }

    /**
     * 제안 공개
     */
    @Transactional
    @PreAuthorize("hasRole('ADMIN') or hasRole('ROLE_MANAGER')")
    public Issue open(Long id) {
        Issue issue = issueRepository.getOne(id);
        return issue.open();
    }
}
