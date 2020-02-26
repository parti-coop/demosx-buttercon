package seoul.democracy.site.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import seoul.democracy.common.exception.AlreadyExistsException;
import seoul.democracy.email.service.EmailService;
import seoul.democracy.user.domain.User;
import seoul.democracy.user.dto.UserCreateDto;
import seoul.democracy.user.service.UserService;
import seoul.democracy.user.utils.UserUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

@Controller
public class LoginController {

    private final UserService userService;
    private final EmailService emailService;
    private final String BLOCK_NEW_USER = System.getProperty("BLOCK_NEW_USER", "true");

    @Autowired
    public LoginController(UserService userService,
                           EmailService emailService) {
        this.userService = userService;
        this.emailService = emailService;
    }

    /**
     * 로그인 화면
     */
    @RequestMapping(value = "/login.do", method = RequestMethod.GET)
    public String login(@RequestParam(value = "login_error", required = false) Long loginError,
                        HttpServletRequest request,
                        HttpSession session,
                        Model model) {

        model.addAttribute("loginError", loginError);

        if (loginError == null) {
            String target = request.getHeader("Referer");
            if (StringUtils.hasText(target)) {
                session.setAttribute("SITE_LOGIN_REDIRECT_URL", target);
            }
        }

        return UserUtils.isLogin() ? "redirect:/index.do" : "/site/login";
    }

    /**
     * 이메일 로그인 화면
     */
    @RequestMapping(value = "/email-login.do", method = RequestMethod.GET)
    public String loginEmail(@RequestParam(value = "login_error", required = false) Long loginError,
                        HttpServletRequest request,
                        HttpSession session,
                        Model model) {

        model.addAttribute("loginError", loginError);

        if (loginError == null) {
            String target = request.getHeader("Referer");
            if (StringUtils.hasText(target)) {
                session.setAttribute("SITE_LOGIN_REDIRECT_URL", target);
            }
        }

        return UserUtils.isLogin() ? "redirect:/index.do" : "/site/email-login";
    }

    /**
     * 회원가입 화면
     */
    @RequestMapping(value = "/join.do", method = RequestMethod.GET)
    public String join(@ModelAttribute("createDto") UserCreateDto createDto) {
        return UserUtils.isLogin() ? "redirect:/index.do" : "/site/join";
    }

    /**
     * 이메일 회원가입 화면
     */
    @RequestMapping(value = "/email-join.do", method = RequestMethod.GET)
    public String joinEmail(@ModelAttribute("createDto") UserCreateDto createDto) {
        return UserUtils.isLogin() ? "redirect:/index.do" : "/site/email-join";
    }

    @RequestMapping(value = "/join.do", method = RequestMethod.POST)
    public String join(@ModelAttribute("createDto") @Valid UserCreateDto createDto,
                       BindingResult result,
                       Model model) {
        if (UserUtils.isLogin()) return "redirect:/index.do";
        if (result.hasErrors()) return "/site/join";
        
        
        /** 회원가입 막는다 */
        if(BLOCK_NEW_USER.equals("true")) {
            return "redirect:/index.do";
        }

        try {
            userService.create(createDto);
        } catch (AlreadyExistsException e) {
            result.rejectValue("email", "email.error", e.getLocalizedMessage());
            return "/site/join";
        }

        model.addAttribute("joinSuccess", true);
        return "/site/join";
    }

    /**
     * 비밀번호 찾기
     */
    @RequestMapping(value = "/find-password.do", method = RequestMethod.GET)
    public String findPassword() {
        return UserUtils.isLogin() ? "redirect:/index.do" : "/site/find-password";
    }

    @RequestMapping(value = "/find-password.do", method = RequestMethod.POST)
    public String findPassword(@RequestParam("email") String email,
                               Model model) throws Exception {
        if (UserUtils.isLogin()) return "redirect:/index.do";

        User user = userService.initPassword(email);
        if (user == null) {
            model.addAttribute("not_found", true);
            model.addAttribute("email", email);
            return "/site/find-password";
        }

        emailService.resetPassword(user.getEmail(), user.getToken());
        model.addAttribute("reset", true);

        return "/site/find-password";
    }

    @RequestMapping(value = "/reset-password.do", method = RequestMethod.GET)
    public String resetPassword(@RequestParam("token") String token,
                                @RequestParam("email") String email,
                                Model model) {
        if (UserUtils.isLogin()) return "redirect:/index.do";

        model.addAttribute("token", token);
        model.addAttribute("email", email);
        return "/site/reset-password";
    }
}
