package seoul.democracy.history.predicate;

import static seoul.democracy.history.domain.IssueHistory.Status.OPEN;
import static seoul.democracy.history.domain.QIssueHistory.issueHistory;

import com.mysema.query.types.ExpressionUtils;
import com.mysema.query.types.Predicate;

public class IssueHistoryPredicate {

    public static Predicate equalId(Long id) {
        return issueHistory.id.eq(id);
    }

    public static Predicate predicateForSite(Long issueId) {
        return ExpressionUtils.and(issueHistory.issue.id.eq(issueId), issueHistory.status.eq(OPEN));
    }

    public static Predicate justBefore(Long historyId, Long issueId) {
        Predicate exp = ExpressionUtils.and(issueHistory.issue.id.eq(issueId), issueHistory.status.eq(OPEN));
        return ExpressionUtils.and(issueHistory.id.lt(historyId), exp);
    }
}
