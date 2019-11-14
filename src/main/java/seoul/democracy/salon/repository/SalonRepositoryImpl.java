package seoul.democracy.salon.repository;

import com.mysema.query.SearchResults;
import com.mysema.query.jpa.JPQLQuery;
import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.support.QueryDslRepositorySupport;

import seoul.democracy.issue.dto.IssueTagDto;
import seoul.democracy.salon.domain.Salon;
import seoul.democracy.salon.dto.SalonDto;
import seoul.democracy.issue.predicate.IssueTagPredicate;

import static seoul.democracy.issue.domain.QCategory.category;
import static seoul.democracy.issue.domain.QIssueStats.issueStats;
import static seoul.democracy.salon.domain.QSalon.salon;
import static seoul.democracy.user.domain.QUser.user;
import static seoul.democracy.user.dto.UserDto.createdBy;
import static seoul.democracy.user.dto.UserDto.modifiedBy;

import java.util.List;

import static seoul.democracy.issue.domain.QIssueTag.issueTag;

public class SalonRepositoryImpl extends QueryDslRepositorySupport implements SalonRepositoryCustom {

    public SalonRepositoryImpl() {
        super(Salon.class);
    }

    private JPQLQuery getQuery(Expression<SalonDto> projection) {
        JPQLQuery query = from(salon);
        if (projection == SalonDto.projection) {
            query.innerJoin(salon.createdBy, createdBy);
            query.innerJoin(salon.modifiedBy, modifiedBy);
            query.innerJoin(salon.stats, issueStats);
        } else if (projection == SalonDto.projectionForSiteList || projection == SalonDto.projectionForSiteDetail) {
            query.innerJoin(salon.createdBy, createdBy);
            query.innerJoin(salon.stats, issueStats);
        } else if (projection == SalonDto.projectionForMypageSalon) {
            query.innerJoin(salon.stats, issueStats);
        }
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
    public SalonDto findOne(Predicate predicate, Expression<SalonDto> projection, boolean withIssueTags) {
        SalonDto salonDto = getQuery(projection).where(predicate).uniqueResult(projection);
        if (salonDto == null)
            return null;

        if (withIssueTags) {
            List<IssueTagDto> issueTags = from(salon).innerJoin(salon.issueTags, issueTag).where(predicate)
                    .orderBy(issueTag.name.asc()).list(IssueTagDto.projection);
            salonDto.setIssueTags(issueTags);
        }

        return salonDto;
    }
}
