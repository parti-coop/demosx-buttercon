package seoul.democracy.butter.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.NotBlank;
import seoul.democracy.issue.dto.IssueFileDto;

import javax.validation.Valid;
import javax.validation.constraints.Size;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor(staticName = "of")
public class ButterCreateDto {
    @NotBlank
    @Size(max = 100)
    private String title;

    @Size(max = 100)
    private String excerpt;

    private String content;
    
    private String processType;

    @Valid
    private List<IssueFileDto> files;

    private String[] issueTagNames;
    private Long[] makerIds;
}
