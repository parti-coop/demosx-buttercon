package seoul.democracy.history.service;

import java.util.List;

import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import seoul.democracy.butter.domain.Butter;
import seoul.democracy.butter.dto.ButterUpdateDto;
import seoul.democracy.butter.repository.ButterRepository;
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.history.domain.IssueHistory;
import seoul.democracy.history.domain.IssueHistory.Status;
import seoul.democracy.history.dto.IssueHistoryCreateDto;
import seoul.democracy.history.dto.IssueHistoryDto;
import seoul.democracy.history.dto.IssueHistoryUpdateDto;
import seoul.democracy.history.repository.IssueHistoryRepository;
import seoul.democracy.issue.domain.Issue;
import seoul.democracy.issue.repository.IssueRepository;

@Service
@Transactional(readOnly = true)
public class IssueHistoryService {

    private final IssueHistoryRepository historyRepository;
    private final IssueRepository issueRepository;
    private final ButterRepository butterRepository;

    @Autowired
    public IssueHistoryService(IssueHistoryRepository historyRepository, IssueRepository issueRepository,
            ButterRepository butterRepository) {
        this.historyRepository = historyRepository;
        this.issueRepository = issueRepository;
        this.butterRepository = butterRepository;
    }

    private IssueHistory getHistory(Long historyId) {
        IssueHistory history = historyRepository.findOne(historyId);
        if (history == null)
            throw new NotFoundException("해당 히스토리를 찾을 수 없습니다.");
        return history;
    }

    public IssueHistoryDto getHistory(Predicate predicate, Expression<IssueHistoryDto> projection) {
        return historyRepository.findOne(predicate, projection);
    }

    public List<IssueHistoryDto> getHistories(Predicate predicate, Expression<IssueHistoryDto> projection) {
        return historyRepository.findAll(predicate, projection);
    }

    @Transactional
    public IssueHistory saveTempHistory(ButterUpdateDto dto) {
        Butter butter = butterRepository.findOne(dto.getId());
        return historyRepository.save(butter.createHistory(dto.getContent(), dto.getExcerpt(), Status.DELETE));
    }

    /**
     * 히스토리 등록
     */
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public IssueHistory create(IssueHistoryCreateDto createDto) {
        Issue issue = issueRepository.findOne(createDto.getIssueId());
        if (issue == null)
            throw new NotFoundException("해당 글을 찾을 수 없습니다.");

        IssueHistory history = issue.createHistory(createDto.getContent());

        return historyRepository.save(history);
    }

    /**
     * 히스토리 수정
     */
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public IssueHistory update(IssueHistoryUpdateDto updateDto) {
        return getHistory(updateDto.getHistoryId()).update(updateDto.getContent());
    }

    /**
     * 히스토리 삭제
     */
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public IssueHistory delete(Long historyId) {
        return getHistory(historyId).delete();
    }

}
