package seoul.democracy.butter.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.querydsl.QueryDslPredicateExecutor;
import seoul.democracy.butter.domain.ButterMaker;

public interface ButterMakerRepository extends JpaRepository<ButterMaker, Long>, QueryDslPredicateExecutor<ButterMaker> {
}
