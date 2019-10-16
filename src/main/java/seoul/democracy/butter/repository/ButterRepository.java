package seoul.democracy.butter.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.querydsl.QueryDslPredicateExecutor;
import seoul.democracy.butter.domain.Butter;

public interface ButterRepository
        extends ButterRepositoryCustom, JpaRepository<Butter, Long>, QueryDslPredicateExecutor<Butter> {
}
