package seoul.democracy.issue.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.GenericGenerator;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import seoul.democracy.issue.domain.Issue;
import seoul.democracy.issue.dto.IssueTagCreateDto;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.*;

/**
 * 태그 Entity
 */
@Getter
@NoArgsConstructor
@Entity(name = "TB_ISSUE_TAG")
@EntityListeners({AuditingEntityListener.class})
public class IssueTag {
    @Id
    @GeneratedValue(generator = "native")
    @GenericGenerator(name = "native", strategy = "native")
    @Column(name = "TAG_ID")
    private Long id;

    /**
     * 태그명
     */
    @Column(name = "TAG_NAME")
    private String name;

    /**
     * 관련 이슈
     */
    @ManyToMany(mappedBy = "tags")
    private Set<Issue> issues = new HashSet<>();

    private IssueTag(String name) {
        this.name = name;
    }

    public static IssueTag create(IssueTagCreateDto createDto) {
        return new IssueTag(createDto.getName());
    }
}