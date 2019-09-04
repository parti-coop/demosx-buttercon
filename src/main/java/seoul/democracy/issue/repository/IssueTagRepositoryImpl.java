package seoul.democracy.issue.repository;

import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;

import org.springframework.data.jpa.repository.support.QueryDslRepositorySupport;
import seoul.democracy.issue.domain.IssueTag;
import seoul.democracy.issue.dto.IssueTagDto;

import java.util.List;

import static seoul.democracy.issue.domain.QIssueTag.issueTag;

public class IssueTagRepositoryImpl extends QueryDslRepositorySupport implements IssueTagRepositoryCustom {

    public IssueTagRepositoryImpl() {
        super(IssueTag.class);
    }

    @Override
    public List<IssueTagDto> findAll(Expression<IssueTagDto> projection) {
        return from(issueTag)
                   .orderBy(issueTag.name.asc())
                   .list(projection);
    }

    @Override
    public List<IssueTagDto> findAll(Predicate predicate, Expression<IssueTagDto> projection) {
        return from(issueTag)
                    .where(predicate)
                   .orderBy(issueTag.name.asc())
                   .list(projection);
    }
}
