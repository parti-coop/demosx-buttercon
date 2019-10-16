package seoul.democracy.butter.predicate;

import com.mysema.query.types.ExpressionUtils;
import com.mysema.query.types.Predicate;
import org.springframework.util.StringUtils;
import seoul.democracy.butter.domain.Butter;
import seoul.democracy.issue.domain.Issue;
import seoul.democracy.issue.domain.IssueGroup;

import static seoul.democracy.butter.domain.QButter.butter;
import static seoul.democracy.issue.domain.Issue.Status.OPEN;

public class ButterPredicate {

    public static Predicate equalId(Long id) {
        return butter.id.eq(id);
    }

    public static Predicate equalIdAndGroup(Long id, IssueGroup group) {
        return ExpressionUtils.and(butter.id.eq(id), butter.group.eq(group));
    }

    public static Predicate equalIdAndStatus(Long id, Issue.Status status) {
        return ExpressionUtils.and(butter.id.eq(id), butter.status.eq(status));
    }

    public static Predicate predicateForAdminList(IssueGroup group, String search, String category) {
        Predicate predicate = null;

        if (StringUtils.hasText(search))
            predicate = ExpressionUtils.or(butter.title.contains(search), butter.createdBy.name.contains(search));

        if (StringUtils.hasText(category))
            predicate = ExpressionUtils.and(predicate, butter.category.name.eq(category));

        return ExpressionUtils.and(predicate, butter.group.eq(group));
    }

    public static Predicate predicateForRelationSelect(String search) {
        Predicate predicate = ExpressionUtils.and(butter.group.eq(IssueGroup.USER), butter.status.eq(OPEN));

        if (StringUtils.isEmpty(search)) return predicate;

        return ExpressionUtils.and(predicate, butter.title.contains(search));
    }

    public static Predicate predicateForSiteList(IssueGroup group, String category, String search) {
        Predicate predicate = ExpressionUtils.and(butter.group.eq(group), butter.status.eq(OPEN));

        if (!StringUtils.isEmpty(category))
            predicate = ExpressionUtils.and(predicate, butter.category.name.eq(category));

        if (StringUtils.isEmpty(search)) return predicate;

        return ExpressionUtils.and(predicate, butter.title.contains(search));
    }

    public static Predicate equalGroup(IssueGroup group) {
        return butter.group.eq(group);
    }
}
