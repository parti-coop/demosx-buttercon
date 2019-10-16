package seoul.democracy.butter.repository;

import com.mysema.query.SearchResults;
import com.mysema.query.jpa.JPQLQuery;
import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.support.QueryDslRepositorySupport;
import seoul.democracy.butter.domain.Butter;
import seoul.democracy.butter.dto.ButterDto;
import seoul.democracy.issue.dto.IssueFileDto;

import java.util.List;

import static seoul.democracy.butter.domain.QButter.butter;
import static seoul.democracy.issue.domain.QCategory.category;
import static seoul.democracy.issue.domain.QIssueFile.issueFile;
import static seoul.democracy.issue.domain.QIssueRelation.issueRelation;
import static seoul.democracy.issue.domain.QIssueStats.issueStats;
import static seoul.democracy.user.dto.UserDto.createdBy;
import static seoul.democracy.user.dto.UserDto.modifiedBy;

public class ButterRepositoryImpl extends QueryDslRepositorySupport implements ButterRepositoryCustom {

    public ButterRepositoryImpl() {
        super(Butter.class);
    }

    private JPQLQuery getQuery(Expression<ButterDto> projection) {
        JPQLQuery query = from(butter);
        if (projection == ButterDto.projection) {
            query.innerJoin(butter.createdBy, createdBy);
            query.innerJoin(butter.modifiedBy, modifiedBy);
            query.innerJoin(butter.category, category);
            query.innerJoin(butter.stats, issueStats);
        } else if (projection == ButterDto.projectionForAdminList || projection == ButterDto.projectionForAdminDetail) {
            query.innerJoin(butter.createdBy, createdBy);
            query.innerJoin(butter.category, category);
            query.innerJoin(butter.stats, issueStats);
        } else if (projection == ButterDto.projectionForSiteList || projection == ButterDto.projectionForSiteDetail) {
            query.innerJoin(butter.category, category);
            query.innerJoin(butter.stats, issueStats);
        }
        return query;
    }

    @Override
    public Page<ButterDto> findAll(Predicate predicate, Pageable pageable, Expression<ButterDto> projection) {
        SearchResults<ButterDto> results = getQuerydsl()
                .applyPagination(pageable, getQuery(projection).where(predicate)).listResults(projection);
        return new PageImpl<>(results.getResults(), pageable, results.getTotal());
    }

    @Override
    public ButterDto findOne(Predicate predicate, Expression<ButterDto> projection, boolean withFiles,
            boolean withRelations) {
        ButterDto butterDto = getQuery(projection).where(predicate).uniqueResult(projection);

        if (butterDto != null && withFiles) {
            List<IssueFileDto> files = from(butter).innerJoin(butter.files, issueFile).where(predicate)
                    .orderBy(issueFile.seq.asc()).list(IssueFileDto.projection);
            butterDto.setFiles(files);
        }

        if (butterDto != null && withRelations) {
            List<Long> relations = from(butter).innerJoin(butter.relations, issueRelation).where(predicate)
                    .orderBy(issueRelation.seq.asc()).list(issueRelation.issueId);
            butterDto.setRelations(relations);
        }

        return butterDto;
    }
}
