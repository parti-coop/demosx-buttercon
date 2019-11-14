package seoul.democracy.salon.repository;

import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import seoul.democracy.salon.dto.SalonDto;

public interface SalonRepositoryCustom {

    Page<SalonDto> findAll(Predicate predicate, Pageable pageable, Expression<SalonDto> projection,
            boolean withIssueTags);

    SalonDto findOne(Predicate predicate, Expression<SalonDto> projection, boolean withIssueTags);
}
