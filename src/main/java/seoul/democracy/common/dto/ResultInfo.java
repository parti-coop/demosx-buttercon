package seoul.democracy.common.dto;

import java.util.Map;
import java.util.LinkedHashMap;

import javax.validation.constraints.NotNull;
import com.fasterxml.jackson.annotation.JsonInclude;
import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor(staticName = "of")
@RequiredArgsConstructor(staticName = "of")
@JsonInclude(NON_EMPTY)
public class ResultInfo {

    @NotNull
    final private String msg;

    Map<String, Object> contents = new LinkedHashMap<>();
}

