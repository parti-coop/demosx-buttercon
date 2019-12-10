package seoul.democracy.user.domain;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.EntityListeners;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToMany;

import org.hibernate.annotations.GenericGenerator;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.springframework.util.StringUtils;

import lombok.Getter;
import lombok.NoArgsConstructor;
import seoul.democracy.butter.domain.Butter;
import seoul.democracy.common.annotation.CreatedIp;
import seoul.democracy.common.converter.LocalDateTimeAttributeConverter;
import seoul.democracy.common.exception.AlreadyExistsException;
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.common.listener.AuditingIpListener;
import seoul.democracy.issue.domain.Category;
import seoul.democracy.user.dto.UserCreateDto;
import seoul.democracy.user.dto.UserManagerCreateDto;
import seoul.democracy.user.dto.UserManagerUpdateDto;
import seoul.democracy.user.dto.UserSocialCreateDto;
import seoul.democracy.user.dto.UserUpdateDto;

/**
 * 회원
 */
@Getter
@NoArgsConstructor
@Entity(name = "TB_USER")
@EntityListeners({AuditingEntityListener.class, AuditingIpListener.class})
public class User implements Serializable {
    private static final long serialVersionUID = 8169967433018770688L;

    @Id
    @GeneratedValue(generator = "native")
    @GenericGenerator(name = "native", strategy = "native")
    @Column(name = "USER_ID")
    private Long id;

    /**
     * 등록 일시
     */
    @Convert(converter = LocalDateTimeAttributeConverter.class)
    @Column(name = "REG_DT", insertable = false, updatable = false)
    private LocalDateTime createdDate;

    /**
     * 등록 아이피
     */
    @CreatedIp
    @Column(name = "REG_IP", updatable = false)
    private String createdIp;

    /**
     * 회원 권한
     */
    @Column(name = "USER_ROLE")
    @Enumerated(EnumType.STRING)
    private Role role;

    /**
     * 회원 상태
     */
    @Column(name = "USER_STATUS")
    @Enumerated(EnumType.STRING)
    private Status status;

    /**
     * 회원 이메일
     */
    @Column(name = "USER_EMAIL", updatable = false)
    private String email;

    /**
     * 공급자, 어떤 회원으로 가입했는지
     */
    @Column(name = "PROVIDER", updatable = false)
    private String provider;

    /**
     * 회원 이름
     */
    @Column(name = "USER_NAME")
    private String name;

    /**
     * 회원 패스워드
     */
    @Column(name = "USER_PASSWD")
    private String password;

    /**
     * 로그인 일시
     */
    @Convert(converter = LocalDateTimeAttributeConverter.class)
    @Column(name = "LOGIN_DT")
    private LocalDateTime loginDate;

    /**
     * 로그인 아이피
     */
    @Column(name = "LOGIN_IP")
    private String loginIp;

    /**
     * 회원 토큰 : 인증이나 패스워드 찾기 시에 사용됨
     */
    @Column(name = "USER_TOKEN", columnDefinition = "char(32)")
    private String token;

    /**
     * 이미지 URL
     */
    @Column(name = "IMG_URL")
    private String photo;

    /**
     * 부서 정보
     */
    @Embedded
    private UserDepartment department;

    @ManyToMany(mappedBy = "butterMakers")
    private Set<Butter> butters = new HashSet<>();

    private User(String email, String provider, String name, String password, String photo) {
        this.email = email;
        this.provider = provider;
        this.name = name;
        this.password = password;
        this.photo = photo;
        this.role = Role.ROLE_USER;
        this.status = Status.ACTIVATED;
    }

    public static User create(UserCreateDto createDto) {
        return new User(createDto.getEmail().trim(), "email", createDto.getName(), createDto.getPassword(), null);
    }

    public static User create(UserSocialCreateDto createDto) {
        return new User(createDto.getEmail(), createDto.getProvider(), createDto.getName(), "", createDto.getPhoto());
    }

    public User update(UserUpdateDto updateDto) {
        this.name = updateDto.getName();
        if(!StringUtils.isEmpty(updateDto.getPhoto())) {
            this.photo = updateDto.getPhoto();
        }
        return this;
    }

    public void updatePassword(String password) {
        this.password = password;
    }

    public User createManager(UserManagerCreateDto createDto, Category category) {
        if (isAdmin()) throw new NotFoundException("해당 사용자가 없습니다.");
        if (isManager()) throw new AlreadyExistsException("이미 담당자로 지정되어 있습니다.");

        this.department = UserDepartment.create(category, createDto.getDepartment1(), createDto.getDepartment2(), createDto.getDepartment3());
        this.role = Role.ROLE_MANAGER;

        return this;
    }

    public User updateManager(UserManagerUpdateDto updateDto, Category category) {
        if (isAdmin() || isUser()) throw new NotFoundException("해당 사용자가 없습니다.");

        this.department.update(updateDto, category);
        return this;
    }

    public User deleteManager() {
        if (isAdmin() || isUser()) throw new NotFoundException("해당 사용자가 없습니다.");

        this.department = null;
        this.role = Role.ROLE_USER;
        return this;
    }

    public UserLogin login(String ip) {
        this.loginIp = ip;
        this.loginDate = LocalDateTime.now();

        return UserLogin.create(this.id, this.loginDate, this.loginIp);
    }

    public User changePassword(String password) {
        this.password = password;
        return this;
    }

    public User initPassword() {
        if (StringUtils.hasText(this.token)) return this;

        this.token = UUID.randomUUID().toString().replace("-", "");

        return this;
    }

    public void resetPassword(String password) {
        this.token = null;
        this.password = password;
    }

    public String viewPhoto() {
        return StringUtils.hasText(photo) ? photo : "/images/noavatar.png";
    }

    public boolean isAdmin() {
        return this.role.isAdmin() || this.role.isManager();
    }

    public boolean isManager() {
        return this.role.isManager();
    }

    public boolean isUser() {
        return this.role.isUser();
    }

    public enum Status {
        ACTIVATED,      // activated, 활성화 상태, 인증 후 상태
        DEACTIVATED,    // deactivated, 비활성화 상태, 탈퇴, 개인 정보 삭제 및 대체
        EXPIRED,        // expired, 1년동안 로그인 안한 경우
    }
}
