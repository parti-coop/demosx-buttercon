package seoul.democracy.proposal.predicate;

import com.mysema.query.jpa.JPASubQuery;
import com.mysema.query.types.ExpressionUtils;
import com.mysema.query.types.Predicate;
import org.springframework.util.StringUtils;
import seoul.democracy.issue.domain.Issue;
import seoul.democracy.proposal.domain.Proposal;
import seoul.democracy.proposal.domain.ProposalType;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import static seoul.democracy.issue.domain.Issue.Status.OPEN;
import static seoul.democracy.proposal.domain.QProposal.proposal;
import static seoul.democracy.issue.domain.QIssueTag.issueTag;

public class ProposalPredicate {

    public static Predicate equalId(Long id) {
        return proposal.id.eq(id);
    }

    public static Predicate equalStatus(Issue.Status status) {
        return proposal.status.eq(status);
    }

    public static Predicate equalIdAndStatus(Long id, Issue.Status status) {
        return ExpressionUtils.and(proposal.id.eq(id), proposal.status.eq(status));
    }

    public static Predicate equalIdAndManagerId(Long id, Long managerId) {
        return ExpressionUtils.and(proposal.id.eq(id), proposal.managerId.eq(managerId));
    }

    public static Predicate predicateForRelationSelect(String search) {
        Predicate predicate = proposal.status.eq(OPEN);

        if (StringUtils.isEmpty(search)) return predicate;

        return ExpressionUtils.and(predicate, proposal.title.contains(search));
    }

    public static Predicate predicateForAdminList(String search, String category, Proposal.Process process, ProposalType proposalType) {
        Predicate predicate = null;

        if (StringUtils.hasText(search))
            predicate = ExpressionUtils.or(proposal.title.contains(search), proposal.createdBy.name.contains(search));

        if (StringUtils.hasText(category))
            predicate = ExpressionUtils.and(predicate, proposal.category.name.eq(category));

        if (process != null)
            predicate = ExpressionUtils.and(predicate, proposal.process.eq(process));

        if (proposalType != null)
            predicate = ExpressionUtils.and(predicate, proposal.proposalType.eq(proposalType));

        return predicate;
    }

    public static Predicate predicateForManagerList(Long managerId, String search, String category, Proposal.Process process, ProposalType proposalType) {
        Predicate predicate = proposal.managerId.eq(managerId);

        return ExpressionUtils.and(predicate, predicateForAdminList(search, category, process, proposalType));
    }

    public static Predicate predicateForSiteList(String search, String category) {
        Predicate predicate = proposal.status.eq(OPEN);

        if (StringUtils.hasText(search))
            for(String word : search.split("\\s")) {
                if(word.startsWith("#")) {
                    predicate = ExpressionUtils.and(predicate,
                        proposal.issueTags.any().in(
                            new JPASubQuery()
                                .from(issueTag)
                                .where(issueTag.name.eq(word.substring(1)))
                                .list(issueTag)
                        ));
                } else {
                    predicate = ExpressionUtils.and(predicate, proposal.title.contains(search));
                    predicate = ExpressionUtils.and(predicate, proposal.content.contains(search));
                }
            }

        if (StringUtils.hasText(category))
            predicate = ExpressionUtils.and(predicate, proposal.category.name.eq(category));

        return predicate;
    }

    public static Predicate predicateForMypageProposal(Long userId, String search) {
        Predicate predicate = ExpressionUtils.and(proposal.createdById.eq(userId), proposal.status.eq(OPEN));

        if (StringUtils.hasText(search))
            predicate = ExpressionUtils.and(predicate, proposal.title.contains(search));

        return predicate;
    }

    public static Predicate predicateForEdit(Long id, Long userId) {
        return ExpressionUtils.allOf(
            proposal.id.eq(id),
            proposal.createdById.eq(userId),
            proposal.status.eq(OPEN));
    }

    public static Predicate predicateForSendDropEmail() {
        LocalDate date = LocalDate.now().minusDays(20);
        LocalDateTime startDateTime = LocalDateTime.of(date, LocalTime.of(0, 0));
        LocalDateTime endDateTime = LocalDateTime.of(date.plusDays(1), LocalTime.of(0, 0));

        return ExpressionUtils.allOf(
            proposal.status.eq(OPEN),
            proposal.process.eq(Proposal.Process.INIT),
            proposal.createdDate.goe(startDateTime),
            proposal.createdDate.lt(endDateTime));
    }

    public static Predicate equalStatusAndProposalType(Issue.Status status, ProposalType proposalType) {
        return ExpressionUtils.and(
            proposal.status.eq(status),
            proposal.proposalType.eq(proposalType)
        );
    }

    public static Predicate equalStatusAndLikeCountOver(Issue.Status status, long likeCount) {
        return ExpressionUtils.and(
            proposal.status.eq(status),
            proposal.stats.likeCount.goe(likeCount)
        );
    }

    public static Predicate equalStatusAndProcess(Issue.Status status, Proposal.Process process) {
        return ExpressionUtils.and(
            proposal.status.eq(status),
            proposal.process.eq(process)
        );
    }
}
