package seoul.democracy.site.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class PolicyController {

    @RequestMapping(value = "/policy.do", method = RequestMethod.GET)
    public String policyHome(Model model) {
        return "/site/policy/index";
    }
}
