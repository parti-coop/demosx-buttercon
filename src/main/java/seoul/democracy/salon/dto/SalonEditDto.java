package seoul.democracy.salon.dto;

import seoul.democracy.issue.dto.IssueFileDto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import seoul.democracy.issue.dto.IssueTagDto;

import org.hibernate.validator.constraints.NotBlank;

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
    private String image;
    private String category;

    private List<IssueTagDto> issueTags;
    private List<IssueFileDto> files;
}
