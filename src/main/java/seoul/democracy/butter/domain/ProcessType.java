package seoul.democracy.butter.domain;

import lombok.Getter;
import lombok.RequiredArgsConstructor;



@Getter
@RequiredArgsConstructor
public enum ProcessType {
    SAVED("임시저장"), // 임시저장
    PUBLISHED("배포"); // 배포

    private final String msg;

    public boolean isSaved() {
        return this == SAVED;
    }

    public boolean isPublished() {
        return this == PUBLISHED;
    }
}