package seoul.democracy.opinion.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import seoul.democracy.issue.domain.Issue;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

/**
 * 제안 의견
 */
@Getter
@NoArgsConstructor
@Entity
@DiscriminatorValue("D")
public class DebateOpinion extends Opinion {

    private DebateOpinion(Issue issue, Vote vote, String content) {
        super(issue, content);
        this.vote = vote;
    }

    public static DebateOpinion create(Issue issue, Vote vote, String content) {
        return new DebateOpinion(issue, vote, content);
    }

    public DebateOpinion createChildOpinion(String content) {
        throw new java.lang.UnsupportedOperationException();
    }
}
