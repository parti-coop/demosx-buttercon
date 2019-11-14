package seoul.democracy.salon.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import seoul.democracy.issue.dto.IssueTagDto;

import org.hibernate.validator.constraints.NotBlank;

import java.util.List;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Data
@NoArgsConstructor
@AllArgsConstructor(staticName = "of")
public class SalonEditDto {

    @NotNull
    private Long id;

    @NotBlank
    @Size(max = 100)
    private String title;

    private String content;

    private List<IssueTagDto> issueTags;
}
