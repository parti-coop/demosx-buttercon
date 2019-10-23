package seoul.democracy.butter.repository;

import java.util.List;

import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;
import seoul.democracy.butter.dto.ButterDto;

public interface ButterRepositoryCustom {

    List<ButterDto> findAll(Predicate predicate, Expression<ButterDto> projection);
    List<ButterDto> findMine(Predicate predicate, Expression<ButterDto> projection);

    ButterDto findOne(Predicate predicate, Expression<ButterDto> projection);
}
