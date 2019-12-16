package seoul.democracy.salon.predicate;

import com.mysema.query.jpa.JPASubQuery;
import com.mysema.query.types.ExpressionUtils;
import com.mysema.query.types.Predicate;
import org.springframework.util.StringUtils;
import seoul.democracy.issue.domain.Issue;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import static seoul.democracy.issue.domain.Issue.Status.OPEN;
import static seoul.democracy.salon.domain.QSalon.salon;
import static seoul.democracy.issue.domain.QIssueTag.issueTag;
import static seoul.democracy.issue.domain.QCategory.category;

public class SalonPredicate {

    public static Predicate equalId(Long id) {
        return salon.id.eq(id);
    }

    public static Predicate equalStatus(Issue.Status status) {
        return salon.status.eq(status);
    }

    public static Predicate equalIdAndStatus(Long id, Issue.Status status) {
        return ExpressionUtils.and(salon.id.eq(id), salon.status.eq(status));
    }

    public static Predicate predicateForRelationSelect(String search) {
        Predicate predicate = salon.status.eq(OPEN);

        if (StringUtils.isEmpty(search))
            return predicate;

        return ExpressionUtils.and(predicate, salon.title.contains(search));
    }

    public static Predicate predicateForSiteList(String search, String category) {
        Predicate predicate = salon.status.eq(OPEN);

        if (StringUtils.hasText(search))
            for (String word : search.split("\\s")) {
                if (word.startsWith("#")) {
                    predicate = ExpressionUtils.and(predicate, salon.issueTags.any().in(new JPASubQuery().from(issueTag)
                            .where(issueTag.name.eq(word.substring(1))).list(issueTag)));
                } else {
                    predicate = ExpressionUtils.and(predicate,
                            ExpressionUtils.anyOf(salon.title.contains(search), salon.content.contains(search)));
                }
            }

        if (StringUtils.hasText(category))
            predicate = ExpressionUtils.and(predicate, salon.category.name.eq(category));

        return predicate;
    }

    public static Predicate predicateForAdminList(String search, String category) {
        Predicate predicate = null;
        if (StringUtils.hasText(search))
            for (String word : search.split("\\s")) {
                if (word.startsWith("#")) {
                    predicate = ExpressionUtils.and(predicate, salon.issueTags.any().in(new JPASubQuery().from(issueTag)
                            .where(issueTag.name.eq(word.substring(1))).list(issueTag)));
                } else {
                    predicate = ExpressionUtils.and(predicate,
                            ExpressionUtils.anyOf(salon.title.contains(search), salon.content.contains(search)));
                }
            }

        if (StringUtils.hasText(category))
            predicate = ExpressionUtils.and(predicate, salon.category.name.eq(category));

        return predicate;
    }

    public static Predicate predicateForMypageSalon(Long userId, String search) {
        Predicate predicate = ExpressionUtils.and(salon.createdById.eq(userId), salon.status.eq(OPEN));

        if (StringUtils.hasText(search))
            predicate = ExpressionUtils.and(predicate, salon.title.contains(search));

        return predicate;
    }

    public static Predicate predicateForEdit(Long id, Long userId) {
        return ExpressionUtils.allOf(salon.id.eq(id), salon.createdById.eq(userId), salon.status.eq(OPEN));
    }

    public static Predicate predicateForSendDropEmail() {
        LocalDate date = LocalDate.now().minusDays(20);
        LocalDateTime startDateTime = LocalDateTime.of(date, LocalTime.of(0, 0));
        LocalDateTime endDateTime = LocalDateTime.of(date.plusDays(1), LocalTime.of(0, 0));

        return ExpressionUtils.allOf(salon.status.eq(OPEN), salon.createdDate.goe(startDateTime),
                salon.createdDate.lt(endDateTime));
    }

    public static Predicate equalStatusAndLikeCountOver(Issue.Status status, long likeCount) {
        return ExpressionUtils.and(salon.status.eq(status), salon.stats.likeCount.goe(likeCount));
    }

    public static Predicate distinctSalonCategories() {
        return ExpressionUtils.allOf(category.enabled.eq(true), salon.status.eq(OPEN));
    }
}
