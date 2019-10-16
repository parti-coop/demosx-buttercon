package seoul.democracy.butter.repository;

import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import seoul.democracy.butter.dto.ButterDto;

public interface ButterRepositoryCustom {

    Page<ButterDto> findAll(Predicate predicate, Pageable pageable, Expression<ButterDto> projection);

    ButterDto findOne(Predicate predicate, Expression<ButterDto> projection, boolean withFiles, boolean withRelations);
}
