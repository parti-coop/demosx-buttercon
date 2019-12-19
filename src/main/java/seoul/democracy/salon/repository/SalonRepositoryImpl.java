package seoul.democracy.salon.repository;

import com.mysema.query.SearchResults;
import com.mysema.query.jpa.JPQLQuery;
import com.mysema.query.support.Expressions;
import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;
import com.mysema.query.types.expr.NumberExpression;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.support.QueryDslRepositorySupport;

import seoul.democracy.issue.dto.CategoryDto;
import seoul.democracy.issue.dto.IssueFileDto;
import seoul.democracy.issue.dto.IssueTagDto;
import seoul.democracy.salon.domain.Salon;
import seoul.democracy.salon.dto.SalonDto;
import seoul.democracy.issue.predicate.IssueTagPredicate;

import static seoul.democracy.issue.domain.QIssueStats.issueStats;
import static seoul.democracy.issue.domain.QCategory.category;
import static seoul.democracy.salon.domain.QSalon.salon;
import static seoul.democracy.user.dto.UserDto.createdBy;
import static seoul.democracy.user.dto.UserDto.modifiedBy;

import java.util.List;

import static seoul.democracy.issue.domain.QIssueTag.issueTag;
import static seoul.democracy.issue.domain.QIssueFile.issueFile;;

public class SalonRepositoryImpl extends QueryDslRepositorySupport implements SalonRepositoryCustom {

    public SalonRepositoryImpl() {
        super(Salon.class);
    }

    private JPQLQuery getQuery(Expression<SalonDto> projection) {
        JPQLQuery query = from(salon);
        query.innerJoin(salon.createdBy, createdBy);
        query.innerJoin(salon.modifiedBy, modifiedBy);
        query.innerJoin(salon.stats, issueStats);
        query.leftJoin(salon.category, category);
        return query;
    }

    @Override
    public Page<SalonDto> findAll(Predicate predicate, Pageable pageable, Expression<SalonDto> projection,
            boolean withIssueTags) {
        SearchResults<SalonDto> results = getQuerydsl().applyPagination(pageable, getQuery(projection).where(predicate))
                .listResults(projection);

        if (withIssueTags) {
            for (SalonDto result : results.getResults()) {
                List<IssueTagDto> issueTags = from(issueTag).where(IssueTagPredicate.containsIssueId(result.getId()))
                        .orderBy(issueTag.name.asc()).list(IssueTagDto.projection);
                result.setIssueTags(issueTags);
            }
        }

        return new PageImpl<>(results.getResults(), pageable, results.getTotal());
    }

    @Override
    public List<SalonDto> findAll(Predicate predicate, Expression<SalonDto> projection) {
        SearchResults<SalonDto> results = getQuery(projection).where(predicate).listResults(projection);
        for (SalonDto result : results.getResults()) {
            List<IssueTagDto> issueTags = from(issueTag).where(IssueTagPredicate.containsIssueId(result.getId()))
                    .orderBy(issueTag.name.asc()).list(IssueTagDto.projection);
            result.setIssueTags(issueTags);
        }
        return results.getResults();
    }

    @Override
    public List<SalonDto> findRandom(Predicate predicate, Expression<SalonDto> projection, int limit) {
        List<SalonDto> results = getQuery(projection).where(predicate).orderBy(issueStats.viewCount.asc()).limit(limit)
                .list(projection);
        for (SalonDto result : results) {
            List<IssueTagDto> issueTags = from(issueTag).where(IssueTagPredicate.containsIssueId(result.getId()))
                    .orderBy(issueTag.name.asc()).list(IssueTagDto.projection);
            result.setIssueTags(issueTags);
        }
        return results;
    }

    @Override
    public SalonDto findOne(Predicate predicate, Expression<SalonDto> projection, boolean withIssueTags) {
        SalonDto salonDto = getQuery(projection).where(predicate).uniqueResult(projection);
        if (salonDto == null)
            return null;

        if (withIssueTags) {
            List<IssueTagDto> issueTags = from(salon).innerJoin(salon.issueTags, issueTag).where(predicate)
                    .orderBy(issueTag.name.asc()).list(IssueTagDto.projection);
            List<IssueFileDto> issueFiles = from(salon).innerJoin(salon.files, issueFile).where(predicate)
                    .list(IssueFileDto.projection);
            salonDto.setIssueTags(issueTags);
            salonDto.setFiles(issueFiles);
        }

        return salonDto;
    }

    @Override
    public List<CategoryDto> getAllSalonCategories(Predicate predicate, Expression<CategoryDto> projection) {
        return from(salon).innerJoin(salon.category, category).where(predicate).distinct().list(projection);
    }

}
