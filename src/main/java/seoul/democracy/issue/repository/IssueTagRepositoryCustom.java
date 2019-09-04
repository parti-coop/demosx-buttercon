package seoul.democracy.issue.repository;

import java.util.List;

import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;

import seoul.democracy.issue.dto.IssueTagDto;

public interface IssueTagRepositoryCustom {
  List<IssueTagDto> findAll(Expression<IssueTagDto> projection);
  List<IssueTagDto> findAll(Predicate predicate, Expression<IssueTagDto> projection);
}
