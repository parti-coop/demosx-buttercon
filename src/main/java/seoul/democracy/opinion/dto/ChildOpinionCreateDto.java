package seoul.democracy.opinion.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.NotBlank;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Data
@NoArgsConstructor
@AllArgsConstructor(staticName = "of")
public class ChildOpinionCreateDto {
    @NotNull
    private Long parentOpinionId;

    @NotBlank
    @Size(max = 1000)
    private String content;
}
