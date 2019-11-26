package seoul.democracy.salon.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.NotBlank;
import seoul.democracy.issue.dto.IssueFileDto;

import java.util.List;

import javax.validation.Valid;
import javax.validation.constraints.Size;

@Data
@NoArgsConstructor
@AllArgsConstructor(staticName = "of")
public class SalonCreateDto {

    @NotBlank
    @Size(max = 100)
    private String title;

    @Size(max = 100)
    private String team;

    @NotBlank
    private String content;

    @NotBlank
    private String category;

    private String[] issueTagNames;
    private String image;

    @Valid
    private List<IssueFileDto> files;
}
