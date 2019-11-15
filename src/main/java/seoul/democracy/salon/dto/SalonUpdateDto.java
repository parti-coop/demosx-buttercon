package seoul.democracy.salon.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

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
    private String image;

    private String content;

    private String[] issueTagNames;
}
