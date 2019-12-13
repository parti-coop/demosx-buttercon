package seoul.democracy.user.service;

import com.mysema.query.types.Predicate;
import com.mysema.query.types.QBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import seoul.democracy.common.exception.AlreadyExistsException;
import seoul.democracy.common.exception.BadRequestException;
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.issue.service.CategoryService;
import seoul.democracy.user.domain.User;
import seoul.democracy.user.domain.UserLogin;
import seoul.democracy.user.dto.*;
import seoul.democracy.user.predicate.UserPredicate;
import seoul.democracy.user.repository.UserLoginRepository;
import seoul.democracy.user.repository.UserRepository;
import seoul.democracy.user.utils.UserUtils;

import static seoul.democracy.user.predicate.UserPredicate.equalEmail;

import java.util.List;

import javax.security.auth.message.AuthException;

@Service
@Transactional(readOnly = true)
public class UserService {

    private final UserRepository userRepository;
    private final UserLoginRepository loginRepository;
    private final PasswordEncoder passwordEncoder;
    private final CategoryService categoryService;

    @Autowired
    public UserService(UserRepository userRepository, UserLoginRepository loginRepository,
            PasswordEncoder passwordEncoder, CategoryService categoryService) {
        this.userRepository = userRepository;
        this.loginRepository = loginRepository;
        this.passwordEncoder = passwordEncoder;
        this.categoryService = categoryService;
    }

    public UserDto getUser(Predicate predicate, QBean<UserDto> projection) {
        return userRepository.findOne(predicate, projection);
    }

    public Page<UserDto> getUsers(Predicate predicate, Pageable pageable, QBean<UserDto> projection) {
        return userRepository.findAll(predicate, pageable, projection);
    }

    public List<UserDto> getUsers(Predicate predicate, QBean<UserDto> projection) {
        return userRepository.findAll(predicate, projection);
    }

    public User getUser(Long id) {
        User user = userRepository.findOne(id);
        if (user == null)
            throw new NotFoundException("회원 정보를 찾을 수 없습니다.");

        return user;
    }

    public User getMe() {
        return getUser(UserUtils.getUserId());
    }

    @Transactional
    public User create(UserCreateDto createDto) {
        if (existsEmail(createDto.getEmail()))
            throw new AlreadyExistsException("이미 사용중인 이메일입니다.");

        String encodedPassword = passwordEncoder.encode(createDto.getPassword());
        createDto.setPassword(encodedPassword);
        User user = User.create(createDto);

        return userRepository.save(user);
    }

    @Transactional
    public User create(UserSocialCreateDto createDto) {
        User user = User.create(createDto);

        return userRepository.save(user);
    }

    @Transactional
    public User update(UserUpdateDto updateDto) {
        User user = getMe();
        return user.update(updateDto);
    }

    @Transactional
    public UserLogin login(String ip) {
        User user = getMe();
        UserLogin userLogin = user.login(ip);
        return loginRepository.save(userLogin);
    }

    private boolean existsEmail(String email) {
        return userRepository.exists(equalEmail(email.trim()));
    }

    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public User createManager(UserManagerCreateDto createDto) {
        User user = getUser(createDto.getUserId());

        return user.createManager(createDto, categoryService.getCategory(createDto.getCategory()));
    }

    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public User updateManager(UserManagerUpdateDto updateDto) {
        User user = getUser(updateDto.getUserId());

        return user.updateManager(updateDto, categoryService.getCategory(updateDto.getCategory()));
    }

    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public User deleteManager(Long userId) {
        User user = getUser(userId);

        return user.deleteManager();
    }

    @Transactional
    public User changePassword(UserPasswordChangeDto changeDto) {
        User user = getMe();

        if (!passwordEncoder.matches(changeDto.getCurrentPassword(), user.getPassword()))
            throw new BadRequestException("password", "error.password", "패스워드가 일치하지 않습니다.");

        String password = passwordEncoder.encode(changeDto.getChangePassword());
        return user.changePassword(password);
    }

    public boolean matchPassword(String password) {
        User user = getMe();
        return passwordEncoder.matches(password, user.getPassword());
    }

    @Transactional
    public User initPassword(String email) {
        User user = userRepository.findOne(equalEmail(email));
        if (user == null)
            return null;

        return user.initPassword();
    }

    @Transactional
    public void resetPassword(UserPasswordResetDto resetDto) {
        User user = userRepository.findOne(equalEmail(resetDto.getEmail()));
        if (user == null || StringUtils.isEmpty(user.getToken()) || !user.getToken().equals(resetDto.getToken()))
            throw new BadRequestException("token", "error.token", "패스워드 설정을 할 수 없습니다.");

        String password = passwordEncoder.encode(resetDto.getPassword());
        user.resetPassword(password);
    }

    @Transactional
    public User getUserBySocial(String provider, String id, String name, String photo) throws UsernameNotFoundException {
        User user = userRepository.findOne(UserPredicate.equalProviderAndId(provider, id));
        if (user == null) {
            throw new UsernameNotFoundException("2019 버터나이프크루 모집이 종료되었습니다.");
            // user = User.create(UserSocialCreateDto.of(id, provider, name, photo));
            // return userRepository.save(user);
        }
        return user;
    }
}
