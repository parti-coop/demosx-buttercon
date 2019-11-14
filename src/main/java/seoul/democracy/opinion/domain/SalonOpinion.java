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
@DiscriminatorValue("S")
public class SalonOpinion extends Opinion {
    private SalonOpinion(Issue issue, String content) {
        super(issue, content);
        this.vote = Vote.ETC;
    }

    public static SalonOpinion create(Issue issue, String content) {
        return new SalonOpinion(issue, content);
    }

    public SalonOpinion createChildOpinion(String content) {
        Issue issue = this.getIssue();
        SalonOpinion childSalonOpinion = SalonOpinion.create(issue, content);
        childSalonOpinion.parentOpinion = this;

        return childSalonOpinion;
    }
}
