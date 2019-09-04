package seoul.democracy.issue.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.querydsl.QueryDslPredicateExecutor;

import seoul.democracy.issue.domain.IssueTag;

public interface IssueTagRepository extends IssueTagRepositoryCustom, JpaRepository<IssueTag, Long>, QueryDslPredicateExecutor<IssueTag> {
}
