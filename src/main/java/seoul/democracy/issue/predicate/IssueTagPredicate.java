package seoul.democracy.issue.predicate;

import com.mysema.query.types.Predicate;

import static seoul.democracy.issue.domain.QIssueTag.issueTag;

import java.util.List;

public class IssueTagPredicate {

    public static Predicate equalId(Long id) {
        return issueTag.id.eq(id);
    }

    public static Predicate equalIdIn(List<Long> issueTags) {
        return issueTag.id.in(issueTags);
    }

    public static Predicate equalName(String name) {
        return issueTag.name.eq(name);
    }

    public static Predicate containsName(String search) {
        return issueTag.name.contains(search);
    }
}
