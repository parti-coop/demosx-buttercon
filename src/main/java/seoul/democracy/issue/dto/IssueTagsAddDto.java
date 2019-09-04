package seoul.democracy.issue.dto;

import org.hibernate.validator.constraints.NotBlank;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Data
@NoArgsConstructor
@AllArgsConstructor(staticName = "of")
public class IssueTagsAddDto {
    @NotNull
    private Long issueId;

    @NotBlank
    @Size(max = 300)
    private String[] names;
}
