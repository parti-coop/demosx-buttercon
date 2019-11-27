package seoul.democracy.salon.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.util.HtmlUtils;

import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.issue.domain.Category;
import seoul.democracy.issue.domain.Issue;
import seoul.democracy.issue.domain.IssueFile;
import seoul.democracy.issue.domain.IssueLike;
import seoul.democracy.issue.domain.IssueStats;
import seoul.democracy.opinion.domain.SalonOpinion;
import seoul.democracy.opinion.dto.OpinionCreateDto;
import seoul.democracy.salon.dto.SalonCreateDto;
import seoul.democracy.salon.dto.SalonUpdateDto;
import seoul.democracy.user.domain.User;

import java.util.List;

import javax.persistence.*;

@Getter
@NoArgsConstructor
@Entity
@DiscriminatorValue("S")
public class Salon extends Issue {

    @Column(name = "ISSUE_TYPE")
    protected String salonType = "Default";
    @Column(name = "ISSUE_PROCESS")
    protected String process = "Default";
    @Column(name = "IMG_URL")
    protected String image;
    @Column(name = "TEAM")
    protected String team;

    public Salon(String title, String content, String image, String team, List<IssueFile> files, String excerpt) {
        this.stats = IssueStats.create();
        this.status = Status.OPEN;
        this.title = title;
        this.content = content;
        this.image = image;
        this.team = team;
        this.files = files;
        this.excerpt = excerpt;
        // updateExcerpt(this.content);
    }

    protected void updateExcerpt(String content) {
        if (StringUtils.hasText(content)) {
            String unescapeString = HtmlUtils.htmlUnescape(content).replaceAll("<.*?>", "").trim();
            this.excerpt = (unescapeString.length() > 100) ? unescapeString.substring(0, 100) : unescapeString;
        }
    }

    public static Salon create(SalonCreateDto createDto) {
        return new Salon(createDto.getTitle(), createDto.getContent(), createDto.getImage(), createDto.getTeam(),
                IssueFile.create(createDto.getFiles()), createDto.getExcerpt());
    }

    public Salon update(SalonUpdateDto updateDto) {
        if (!status.isOpen())
            throw new NotFoundException("해당 아이디어를 찾을 수 없습니다.");

        this.title = updateDto.getTitle();
        this.content = updateDto.getContent();
        this.image = updateDto.getImage();
        this.team = updateDto.getTeam();
        this.updateFiles(updateDto.getFiles());
        this.excerpt = updateDto.getExcerpt();
        // updateExcerpt(this.content);

        return this;
    }

    public Salon delete() {
        if (!status.isOpen())
            throw new NotFoundException("해당 아이디어를 찾을 수 없습니다.");

        this.status = Status.DELETE;
        return this;
    }

    public Salon block() {
        if (!status.isOpen())
            throw new NotFoundException("해당 아이디어를 찾을 수 없습니다.");

        this.status = Status.CLOSED;
        return this;
    }

    public Salon open() {
        if (status.isDelete())
            throw new NotFoundException("해당 아이디어를 찾을 수 없습니다.");

        this.status = Status.OPEN;
        return this;
    }

    public Salon updateCategory(Category category) {
        this.category = category;
        return this;
    }

    @Override
    public SalonOpinion createOpinion(OpinionCreateDto createDto) {
        return SalonOpinion.create(this, createDto.getContent());
    }

    @Override
    public boolean isUpdatableOpinion() {
        return status.isOpen();
    }

    public IssueLike createLike(User user) {
        if (!status.isOpen())
            throw new NotFoundException("해당 아이디어를 찾을 수 없습니다.");

        return IssueLike.create(user, this);
    }

    public void deleteLike() {
    }
}
