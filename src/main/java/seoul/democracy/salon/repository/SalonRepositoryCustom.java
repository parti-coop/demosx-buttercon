package seoul.democracy.salon.repository;

import java.util.List;

import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import seoul.democracy.issue.dto.CategoryDto;
import seoul.democracy.salon.dto.SalonDto;

public interface SalonRepositoryCustom {

    Page<SalonDto> findAll(Predicate predicate, Pageable pageable, Expression<SalonDto> projection,
            boolean withIssueTags);

    List<SalonDto> findAll(Predicate predicate, Expression<SalonDto> projection);
    List<SalonDto> findRandom(Predicate predicate, Expression<SalonDto> projection, int limit);
    List<CategoryDto> getAllSalonCategories(Predicate predicate, Expression<CategoryDto> projection);

    SalonDto findOne(Predicate predicate, Expression<SalonDto> projection, boolean withIssueTags);
}
