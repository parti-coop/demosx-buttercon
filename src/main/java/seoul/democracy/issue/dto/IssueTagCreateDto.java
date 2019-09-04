package seoul.democracy.issue.dto;

import org.hibernate.validator.constraints.NotBlank;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import javax.validation.constraints.Size;

@Data
@NoArgsConstructor
@AllArgsConstructor(staticName = "of")
public class IssueTagCreateDto {
    @NotBlank
    @Size(max = 300)
    private String name;
}
