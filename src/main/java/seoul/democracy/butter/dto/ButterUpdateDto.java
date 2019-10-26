package seoul.democracy.butter.dto;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import seoul.democracy.user.utils.UserUtils;

@Data
@NoArgsConstructor
@AllArgsConstructor(staticName = "of")
public class ButterUpdateDto {

    @NotNull
    private Long id;

    @Size(max = 100)
    private String title;
    private String content;
    private String excerpt;
    private String[] issueTagNames;
    private Long[] makerIds;
    private Long recentHistoryId;
    private String slackUrl;
    private String slackChannel;
    private Boolean isConflict = false;

    public Boolean isMaker() {
        Long id = UserUtils.getUserId();
        for (Long makerId : this.makerIds) {
            if (makerId.equals(id)) {
                return true;
            }
        }
        return false;
    }

}
