package seoul.democracy.issue.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import seoul.democracy.issue.domain.Issue;
import seoul.democracy.issue.domain.IssueTag;
import seoul.democracy.issue.dto.IssueTagCreateDto;
import seoul.democracy.issue.dto.IssueTagDto;
import seoul.democracy.issue.repository.IssueRepository;
import seoul.democracy.issue.repository.IssueTagRepository;
import static seoul.democracy.issue.dto.IssueTagDto.projection;
import static seoul.democracy.issue.predicate.IssuePredicate.containsIssueTag;
import static seoul.democracy.issue.predicate.IssueTagPredicate.equalName;

import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import com.mysema.query.types.Predicate;

@Service
@Transactional(readOnly = true)
public class IssueTagService {

    private final IssueTagRepository issueTagRepository;
    private final IssueRepository issueRepository;

    @Autowired
    public IssueTagService(IssueTagRepository issueTagRepository,
            IssueRepository issueRepository) {
        this.issueTagRepository = issueTagRepository;
        this.issueRepository = issueRepository;
    }

    public List<IssueTagDto> getIssueTags() {
        return issueTagRepository.findAll(projection);
    }

    public List<IssueTagDto> getIssueTags(Predicate predicate) {
        return issueTagRepository.findAll(predicate, projection);
    }

    /**
     * 태그 추가
     */
    @Transactional
    public Set<IssueTag> changeIssueTags(Long issueId, final String[] names) {
        Issue issue = issueRepository.findOne(issueId);
        if(names == null || names.length == 0) {
            issue.removeTagAll();
            return issue.getIssueTags();
        }

        for (String name : names) {
            IssueTag issueTag = issueTagRepository.findOne(equalName(name));
            if (issueTag == null) {
                IssueTagCreateDto createDto = new IssueTagCreateDto();
                createDto.setName(name);
                issueTag = this.create(createDto);
            }
            issue.addTag(issueTag);
        }

        List<IssueTag> detaggedIssueTags = issue.getIssueTags().stream()
                .filter(issueTag -> !Arrays.stream(names).anyMatch(issueTag.getName()::equals))
                .collect(Collectors.toList());
        for (IssueTag detaggedIssueTag : detaggedIssueTags) {
            issue.removeTag(detaggedIssueTag);

            if (!issueRepository.exists(containsIssueTag(detaggedIssueTag))) {
                issueTagRepository.delete(detaggedIssueTag);
            }
        }

        issueRepository.save(issue);
        return issue.getIssueTags();
    }

    /**
     * 태그 등록
     */
    @Transactional
    public IssueTag create(IssueTagCreateDto createDto) {
        IssueTag issueTag = IssueTag.create(createDto);

        return issueTagRepository.save(issueTag);
    }
}
