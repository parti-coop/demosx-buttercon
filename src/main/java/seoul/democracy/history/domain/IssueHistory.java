package seoul.democracy.history.domain;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.EntityListeners;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;

import org.hibernate.annotations.GenericGenerator;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import lombok.Getter;
import lombok.NoArgsConstructor;
import seoul.democracy.common.annotation.CreatedIp;
import seoul.democracy.common.annotation.ModifiedIp;
import seoul.democracy.common.converter.LocalDateTimeAttributeConverter;
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.common.listener.AuditingIpListener;
import seoul.democracy.issue.domain.Issue;
import seoul.democracy.user.domain.User;

@Getter
@NoArgsConstructor
@Entity(name = "TB_ISSUE_HISTORY")
@EntityListeners({ AuditingEntityListener.class, AuditingIpListener.class })
public class IssueHistory {

    @Id
    @GeneratedValue(generator = "native")
    @GenericGenerator(name = "native", strategy = "native")
    @Column(name = "HISTORY_ID")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ISSUE_ID", updatable = false, nullable = false)
    private Issue issue;

    /**
     * 등록 일시
     */
    @Convert(converter = LocalDateTimeAttributeConverter.class)
    @Column(name = "REG_DT", insertable = false, updatable = false)
    private LocalDateTime createdDate;

    /**
     * 수정 일시
     */
    @LastModifiedDate
    @Convert(converter = LocalDateTimeAttributeConverter.class)
    @Column(name = "CHG_DT", insertable = false)
    private LocalDateTime modifiedDate;

    /**
     * 등록 ID
     */
    @CreatedBy
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "REG_ID", updatable = false, nullable = false)
    private User createdBy;
    @Column(name = "REG_ID", insertable = false, updatable = false)
    private Long createdById;

    /**
     * 수정 ID
     */
    @LastModifiedBy
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "CHG_ID", nullable = false)
    private User modifiedBy;

    /**
     * 등록 아이피
     */
    @CreatedIp
    @Column(name = "REG_IP", updatable = false)
    private String createdIp;

    /**
     * 수정 아이피
     */
    @ModifiedIp
    @Column(name = "CHG_IP")
    private String modifiedIp;

    /**
     * 히스토리 상태
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "HISTORY_STATUS")
    private Status status;

    /**
     * 변경 요약
     */
    @Column(name = "EXCERPT")
    private String excerpt;

    /**
     * 히스토리 내용
     */
    @Lob
    @Column(name = "HISTORY_CONTENT")
    private String content;

    private IssueHistory(Issue issue, String content) {
        this.status = Status.OPEN;
        this.issue = issue;
        this.content = content;
    }

    private IssueHistory(Issue issue, String content, String excerpt) {
        this.status = Status.OPEN;
        this.issue = issue;
        this.content = content;
        this.excerpt = excerpt;
    }

    private IssueHistory(Issue issue, String content, String excerpt, Status status) {
        this.status = status;
        this.issue = issue;
        this.content = content;
        this.excerpt = excerpt;
    }

    public static IssueHistory create(Issue issue, String content) {
        return new IssueHistory(issue, content);
    }

    public static IssueHistory create(Issue issue, String content, String excerpt) {
        return new IssueHistory(issue, content, excerpt);
    }

    public static IssueHistory create(Issue issue, String content, String excerpt, Status status) {
        return new IssueHistory(issue, content, excerpt, status);
    }

    public IssueHistory update(String content) {
        if (this.status.isDelete())
            throw new NotFoundException("해당 히스토리를 찾을 수 없습니다.");

        this.content = content;
        return this;
    }

    public IssueHistory delete() {
        if (this.status.isDelete())
            throw new NotFoundException("해당 히스토리를 찾을 수 없습니다.");

        this.status = Status.DELETE;
        return this;
    }

    public enum Status {
        OPEN, DELETE;

        public boolean isDelete() {
            return this == DELETE;
        }
    }
}
