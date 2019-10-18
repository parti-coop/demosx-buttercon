package seoul.democracy.user.repository;

import com.mysema.query.SearchResults;
import com.mysema.query.jpa.JPQLQuery;
import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.support.QueryDslRepositorySupport;
import seoul.democracy.user.domain.User;
import seoul.democracy.user.dto.UserDto;

import static seoul.democracy.issue.domain.QCategory.category;
import static seoul.democracy.user.domain.QUser.user;

import java.util.List;

public class UserRepositoryImpl extends QueryDslRepositorySupport implements UserRepositoryCustom {

    public UserRepositoryImpl() {
        super(User.class);
    }

    private JPQLQuery getQuery(Expression<UserDto> projection) {
        JPQLQuery query = from(user);
        if (projection == UserDto.projection || projection == UserDto.projectionForAdminManager) {
            query.leftJoin(user.department.category, category);
        }
        return query;
    }

    @Override
    public Page<UserDto> findAll(Predicate predicate, Pageable pageable, Expression<UserDto> projection) {
        SearchResults<UserDto> results = getQuerydsl().applyPagination(pageable, getQuery(projection).where(predicate))
                .listResults(projection);
        return new PageImpl<>(results.getResults(), pageable, results.getTotal());
    }

    @Override
    public UserDto findOne(Predicate predicate, Expression<UserDto> projection) {
        return getQuery(projection).where(predicate).uniqueResult(projection);
    }

    @Override
    public List<UserDto> findAll(Predicate predicate, Expression<UserDto> projection) {
        SearchResults<UserDto> results = getQuery(projection).where(predicate).listResults(projection);
        return results.getResults();
    }
}
