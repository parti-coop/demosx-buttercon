package seoul.democracy.site.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import seoul.democracy.common.dto.ResultInfo;
import seoul.democracy.common.dto.ResultRedirectInfo;
import seoul.democracy.butter.domain.Butter;
import seoul.democracy.butter.dto.ButterCreateDto;
import seoul.democracy.butter.dto.ButterUpdateDto;
import seoul.democracy.butter.service.ButterService;
import seoul.democracy.issue.domain.IssueGroup;
import seoul.democracy.user.dto.UserDto;
import seoul.democracy.user.service.UserService;

import javax.validation.Valid;
import java.util.List;

import static seoul.democracy.user.dto.UserDto.*;
import static seoul.democracy.user.predicate.UserPredicate.containsNameOrEmail;

@RestController
@RequestMapping("/ajax/butter")
public class ButterAjaxController {

    @Autowired private ButterService butterService;
    @Autowired private UserService userService;

    @RequestMapping(value = "/", method = RequestMethod.POST)
    public ResultRedirectInfo newButter(@RequestBody @Valid ButterCreateDto createDto) throws Exception {
        Butter butter = butterService.create(IssueGroup.USER, createDto);
        return ResultRedirectInfo.of("아이디어를 등록하였습니다.", "/butter.do?id=" + butter.getId());
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.PUT)
    public ResultInfo editButter(@PathVariable("id") Long id, @RequestBody @Valid ButterUpdateDto updateDto) {
        butterService.update(updateDto);

        return ResultInfo.of("아이디어를 수정하였습니다.");
    }

    @RequestMapping(value = "/maker", method = RequestMethod.GET)
    public List<UserDto> getUsers(@RequestParam(value = "q") String search, Model model) {
        return userService.getUsers(containsNameOrEmail(search), projectionForBasic);
    }
}
