package seoul.democracy.salon.domain;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;

@Getter
@RequiredArgsConstructor
public enum SalonSort {
    latest(new Sort(Sort.Direction.DESC, "createdDate")),
    like(new Sort(Sort.Direction.DESC, "stats.likeCount", "createdDate")),
    opinion(new Sort(Sort.Direction.DESC, "stats.etcCount", "createdDate"));

    private final Sort sort;
}
