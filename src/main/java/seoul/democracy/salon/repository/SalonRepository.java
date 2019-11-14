package seoul.democracy.salon.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.querydsl.QueryDslPredicateExecutor;
import seoul.democracy.salon.domain.Salon;

public interface SalonRepository
                extends SalonRepositoryCustom, JpaRepository<Salon, Long>, QueryDslPredicateExecutor<Salon> {
}
