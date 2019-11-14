package seoul.democracy.salon.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.util.HtmlUtils;
import seoul.democracy.common.converter.LocalDateTimeAttributeConverter;
import seoul.democracy.common.exception.BadRequestException;
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.issue.domain.Issue;
import seoul.democracy.issue.domain.IssueLike;
import seoul.democracy.issue.domain.IssueStats;
import seoul.democracy.opinion.domain.SalonOpinion;
import seoul.democracy.opinion.dto.OpinionCreateDto;
import seoul.democracy.salon.dto.SalonCreateDto;
import seoul.democracy.salon.dto.SalonUpdateDto;
import seoul.democracy.user.domain.User;

import javax.persistence.*;
import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@Entity
@DiscriminatorValue("S")
public class Salon extends Issue {

    @Column(name = "ISSUE_TYPE")
    protected String salonType = "Default";
    @Column(name = "ISSUE_PROCESS")
    protected String process = "Default";

    /**
     * 관리자 댓글 일시
     */
    @Convert(converter = LocalDateTimeAttributeConverter.class)
    @Column(name = "ADMIN_COMMENT_DT")
    protected LocalDateTime adminCommentDate;

    /**
     * 관리자 댓글
     */
    @Lob
    @Column(name = "ADMIN_COMMENT")
    protected String adminComment;

    /**
     * 매니저 - 담당자
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MANAGER_ID")
    protected User manager;
    @Column(name = "MANAGER_ID", insertable = false, updatable = false)
    protected Long managerId;

    /**
     * 담당자 댓글 일시
     */
    @Convert(converter = LocalDateTimeAttributeConverter.class)
    @Column(name = "MANAGER_COMMENT_DT")
    protected LocalDateTime managerCommentDate;

    /**
     * 담당자 댓글
     */
    @Lob
    @Column(name = "MANAGER_COMMENT")
    protected String managerComment;

    public Salon(String title, String content) {
        this.stats = IssueStats.create();
        this.status = Status.OPEN;
        this.title = title;
        this.content = content;
        updateExcerpt(this.content);
    }

    protected void updateExcerpt(String content) {
        if (StringUtils.hasText(content)) {
            String unescapeString = HtmlUtils.htmlUnescape(content).replaceAll("<.*?>", "").trim();
            this.excerpt = (unescapeString.length() > 100) ? unescapeString.substring(0, 100) : unescapeString;
        }
    }

    public static Salon create(SalonCreateDto createDto) {
        return new Salon(createDto.getTitle(), createDto.getContent());
    }

    public Salon update(SalonUpdateDto updateDto) {
        if (!status.isOpen())
            throw new NotFoundException("해당 아이디어를 찾을 수 없습니다.");

        this.title = updateDto.getTitle();
        this.content = updateDto.getContent();
        updateExcerpt(this.content);

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

    public Salon editAdminComment(String comment) {
        if (!status.isOpen())
            throw new NotFoundException("해당 아이디어를 찾을 수 없습니다.");

        this.adminComment = comment;
        this.adminCommentDate = LocalDateTime.now();
        return this;
    }

    public Salon assignManager(User manager) {
        if (!status.isOpen())
            throw new NotFoundException("해당 아이디어를 찾을 수 없습니다.");

        if (!manager.isManager())
            throw new BadRequestException("role", "error.role", "담당자로 지정되어 있지 않습니다.");

        this.manager = manager;
        return this;
    }

    public Salon editManagerComment(String comment) {
        this.managerComment = comment;
        this.managerCommentDate = LocalDateTime.now();
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
