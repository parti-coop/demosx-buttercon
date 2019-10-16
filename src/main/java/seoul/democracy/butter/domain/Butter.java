package seoul.democracy.butter.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;

import seoul.democracy.butter.dto.ButterCreateDto;
import seoul.democracy.butter.dto.ButterUpdateDto;
import seoul.democracy.issue.domain.*;
import seoul.democracy.opinion.domain.Opinion;
import seoul.democracy.opinion.domain.ProposalOpinion;
import seoul.democracy.opinion.dto.OpinionCreateDto;

import javax.persistence.*;
import java.util.List;

@Getter
@NoArgsConstructor
@Entity
@DiscriminatorValue("B")
public class Butter extends Issue {
    /**
     * 문서 메이커
     */
    // @ManyToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    // @JoinTable(name = "TB_ISSUE_MAKER",
    // joinColumns = @JoinColumn(name = "ISSUE_ID", referencedColumnName =
    // "ISSUE_ID"),
    // inverseJoinColumns = @JoinColumn(name = "TAG_ID", referencedColumnName =
    // "TAG_ID"))
    // private Set<User> issueMakers = new HashSet<>();

    /**
     * 이슈 과정
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "ISSUE_PROCESS")
    private ProcessType processType;

    public Butter update(ButterUpdateDto updateDto, Category category) {
        this.status = updateDto.getStatus();
        this.category = category;
        this.title = updateDto.getTitle();
        this.excerpt = updateDto.getExcerpt();
        this.content = updateDto.getContent();

        updateFiles(updateDto.getFiles());
        updateRelations(updateDto.getRelations());

        return this;
    }

    @Override
    public Opinion createOpinion(OpinionCreateDto createDto) {
        return ProposalOpinion.create(this, createDto.getContent());
    }

    @Override
    public boolean isUpdatableOpinion() {
        return status.isOpen();
    }

    private Butter(IssueGroup group, String title, String excerpt, String content, List<IssueFile> files) {
        this.group = group;
        this.title = title;
        this.excerpt = excerpt;
        this.content = content;
        this.files = files;
        this.processType =  ProcessType.PUBLISHED;
        // this.processType = ProcessType.valueOf(processType);

        this.status = Status.OPEN;
        this.stats = IssueStats.create();
    }

    public static Butter create(IssueGroup group, ButterCreateDto createDto) {
        return new Butter(group, createDto.getTitle(), createDto.getExcerpt(), createDto.getContent(),
                IssueFile.create(createDto.getFiles()));
    }

}
