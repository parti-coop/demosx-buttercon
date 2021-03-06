package seoul.democracy.butter.domain;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;

import lombok.Getter;
import lombok.NoArgsConstructor;
import seoul.democracy.butter.dto.ButterCreateDto;
import seoul.democracy.butter.dto.ButterUpdateDto;
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.history.domain.IssueHistory;
import seoul.democracy.issue.domain.Issue;
import seoul.democracy.issue.domain.IssueFile;
import seoul.democracy.issue.domain.IssueGroup;
import seoul.democracy.issue.domain.IssueStats;
import seoul.democracy.opinion.domain.Opinion;
import seoul.democracy.opinion.domain.ProposalOpinion;
import seoul.democracy.opinion.dto.OpinionCreateDto;
import seoul.democracy.user.domain.User;

@Getter
@NoArgsConstructor
@Entity
@DiscriminatorValue("B")
public class Butter extends Issue {
    /**
     * 문서 메이커
     */
    @ManyToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinTable(name = "TB_ISSUE_MAKER", joinColumns = @JoinColumn(name = "ISSUE_ID", referencedColumnName = "ISSUE_ID"), inverseJoinColumns = @JoinColumn(name = "USER_ID", referencedColumnName = "USER_ID"))
    private Set<User> butterMakers = new HashSet<>();

    /* 메이커 추가 */
    public void addMaker(User user) {
        this.butterMakers.add(user);
    }

    /* 메이커 제거 */
    public void removeMaker(User user) {
        this.butterMakers.remove(user);
    }

    /**
     * 메이커 모두 삭제
     */
    public void removeAllMaker() {
        this.butterMakers.clear();
    }

    /**
     * 이슈 과정
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "ISSUE_PROCESS")
    private ProcessType processType;

    public Butter update(ButterUpdateDto updateDto, Boolean wasMaker) {
        if (wasMaker && updateDto.getIsConflict() == false) {
            this.title = updateDto.getTitle();
        }
        this.slackChannel = updateDto.getSlackChannel();
        this.slackUrl = updateDto.getSlackUrl();
        this.content = updateDto.getContent();
        return this;
    }

    /**
     * 슬랙 웹훅 url
     */
    @Column(name = "SLACK_URL")
    private String slackUrl;

    /**
     * 슬랙 웹훅 channel
     */
    @Column(name = "SLACK_CHANNEL")
    private String slackChannel;

    @Override
    public Opinion createOpinion(OpinionCreateDto createDto) {
        return ProposalOpinion.create(this, createDto.getContent());
    }

    @Override
    public boolean isUpdatableOpinion() {
        return status.isOpen();
    }

    private Butter(String title, String excerpt, String content, List<IssueFile> files, String slackUrl,
            String slackChannel) {
        this.title = title;
        this.excerpt = excerpt;
        this.content = content;
        this.files = files;
        this.slackUrl = slackUrl;
        this.slackChannel = slackChannel;

        this.group = IssueGroup.USER;
        this.processType = ProcessType.PUBLISHED;
        this.status = Status.OPEN;
        this.stats = IssueStats.create();
    }

    public static Butter create(ButterCreateDto createDto) {
        return new Butter(createDto.getTitle(), createDto.getExcerpt(), createDto.getContent(),
                IssueFile.create(createDto.getFiles()), createDto.getSlackUrl(), createDto.getSlackChannel());
    }

    public IssueHistory createHistory(String content, String excerpt) {
        return IssueHistory.create(this, content, excerpt);
    }

    public IssueHistory createHistory(String content, String excerpt, IssueHistory.Status status) {
        return IssueHistory.create(this, content, excerpt, status);
    }

    public Butter delete() {
        if (this.status.isDelete())
            throw new NotFoundException("해당 버터를 찾을 수 없습니다.");

        this.status = Status.DELETE;
        return this;
    }
}
