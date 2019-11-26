package seoul.democracy.salon.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import seoul.democracy.issue.dto.IssueFileDto;

import java.util.List;

import org.hibernate.validator.constraints.NotBlank;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Data
@NoArgsConstructor
@AllArgsConstructor(staticName = "of")
public class SalonUpdateDto {

    @NotNull
    private Long id;

    @NotBlank
    @Size(max = 100)
    private String title;

    @Size(max = 100)
    private String team;

    private String image;

    @NotBlank
    private String content;

    private String category;

    private String[] issueTagNames;
    private List<IssueFileDto> files;
}
