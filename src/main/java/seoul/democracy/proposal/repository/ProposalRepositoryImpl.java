package seoul.democracy.proposal.repository;

import com.mysema.query.SearchResults;
import com.mysema.query.jpa.JPQLQuery;
import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.support.QueryDslRepositorySupport;

import seoul.democracy.issue.dto.IssueTagDto;
import seoul.democracy.proposal.domain.Proposal;
import seoul.democracy.proposal.dto.ProposalDto;
import seoul.democracy.issue.predicate.IssueTagPredicate;

import static seoul.democracy.issue.domain.QCategory.category;
import static seoul.democracy.issue.domain.QIssueStats.issueStats;
import static seoul.democracy.proposal.domain.QProposal.proposal;
import static seoul.democracy.user.domain.QUser.user;
import static seoul.democracy.user.dto.UserDto.createdBy;
import static seoul.democracy.user.dto.UserDto.modifiedBy;

import java.util.List;

import static seoul.democracy.issue.domain.QIssueTag.issueTag;

public class ProposalRepositoryImpl extends QueryDslRepositorySupport implements ProposalRepositoryCustom {

    public ProposalRepositoryImpl() {
        super(Proposal.class);
    }

    private JPQLQuery getQuery(Expression<ProposalDto> projection) {
        JPQLQuery query = from(proposal);
        if (projection == ProposalDto.projection) {
            query.innerJoin(proposal.createdBy, createdBy);
            query.innerJoin(proposal.modifiedBy, modifiedBy);
            query.leftJoin(proposal.category, category);
            query.innerJoin(proposal.stats, issueStats);
            query.leftJoin(proposal.manager, user);
        } else if (projection == ProposalDto.projectionForAdminList
                       || projection == ProposalDto.projectionForAdminDetail
                       || projection == ProposalDto.projectionForSiteList
                       || projection == ProposalDto.projectionForSiteDetail) {
            query.innerJoin(proposal.createdBy, createdBy);
            query.leftJoin(proposal.category, category);
            query.innerJoin(proposal.stats, issueStats);
            query.leftJoin(proposal.manager, user);
        } else if (projection == ProposalDto.projectionForAssignManager) {
            query.leftJoin(proposal.manager, user);
        } else if (projection == ProposalDto.projectionForMypageProposal) {
            query.innerJoin(proposal.stats, issueStats);
        }
        return query;
    }

    @Override
    public Page<ProposalDto> findAll(Predicate predicate, Pageable pageable, Expression<ProposalDto> projection, boolean withIssueTags) {
        SearchResults<ProposalDto> results = getQuerydsl()
                                                 .applyPagination(
                                                     pageable,
                                                     getQuery(projection)
                                                         .where(predicate))
                                                 .listResults(projection);

        if (withIssueTags) {
            for(ProposalDto result : results.getResults()) {
                List<IssueTagDto> issueTags = from(issueTag)
                                    .where(IssueTagPredicate.containsIssueId(result.getId()))
                                    .orderBy(issueTag.name.asc())
                                    .list(IssueTagDto.projection);
                result.setIssueTags(issueTags);
            }
        }

        return new PageImpl<>(results.getResults(), pageable, results.getTotal());
    }

    @Override
    public ProposalDto findOne(Predicate predicate, Expression<ProposalDto> projection, boolean withIssueTags) {
        ProposalDto proposalDto = getQuery(projection)
                                    .where(predicate)
                                    .uniqueResult(projection);
        if (proposalDto == null) return null;

        if (withIssueTags) {
            List<IssueTagDto> issueTags = from(proposal)
                                .innerJoin(proposal.issueTags, issueTag)
                                .where(predicate)
                                .orderBy(issueTag.name.asc())
                                .list(IssueTagDto.projection);
            proposalDto.setIssueTags(issueTags);
        }

        return proposalDto;
    }
}
