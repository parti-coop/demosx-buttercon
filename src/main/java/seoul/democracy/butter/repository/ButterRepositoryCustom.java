package seoul.democracy.butter.repository;

import java.util.List;

import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import seoul.democracy.butter.dto.ButterDto;

public interface ButterRepositoryCustom {

    List<ButterDto> findAll(Predicate predicate, Expression<ButterDto> projection);
    Page<ButterDto> findAll(Predicate predicate, Pageable pageable, Expression<ButterDto> projection);
    List<ButterDto> findMine(Predicate predicate, Expression<ButterDto> projection);

    ButterDto findOne(Predicate predicate, Expression<ButterDto> projection);
}
