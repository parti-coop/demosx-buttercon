package seoul.democracy.site.restcontroller;

import static seoul.democracy.user.dto.UserDto.projectionForBasic;
import static seoul.democracy.user.predicate.UserPredicate.containsNameOrEmail;

import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import seoul.democracy.butter.domain.Butter;
import seoul.democracy.butter.dto.ButterCreateDto;
import seoul.democracy.butter.dto.ButterUpdateDto;
import seoul.democracy.butter.service.ButterService;
import seoul.democracy.common.dto.ResultRedirectInfo;
import seoul.democracy.history.dto.IssueHistoryDto;
import seoul.democracy.history.predicate.IssueHistoryPredicate;
import seoul.democracy.history.service.IssueHistoryService;
import seoul.democracy.user.dto.UserDto;
import seoul.democracy.user.service.UserService;

@RestController
@RequestMapping("/ajax/butter")
public class ButterAjaxController {

    @Autowired
    private ButterService butterService;
    @Autowired
    private UserService userService;
    @Autowired
    private IssueHistoryService issueHistoryService;

    @RequestMapping(value = "/", method = RequestMethod.POST)
    public ResultRedirectInfo newButter(@RequestBody @Valid ButterCreateDto createDto) throws Exception {
        Butter butter = butterService.create(createDto);
        return ResultRedirectInfo.of("보드가 개설되었습니다.", "/butter.do?id=" + butter.getId());
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.PUT)
    public ResultRedirectInfo editButter(@PathVariable("id") Long id, @RequestBody @Valid ButterUpdateDto dto) {
        IssueHistoryDto recentHistory = issueHistoryService.getHistory(IssueHistoryPredicate.byIssueId(id),
                IssueHistoryDto.projectionForSite);
        if (!recentHistory.getId().equals(dto.getRecentHistoryId())) {
            Long afterId = issueHistoryService.saveTempHistory(dto).getId();
            return ResultRedirectInfo.of("다른 사람과 동시에 버터를 추가했습니다. '확인'을 눌러 다시 버터를 추가해주세요.",
                    "/butter-conflict.do?" + "afterId=" + afterId + "&beforeId=" + recentHistory.getId());
        }
        butterService.update(dto);
        return ResultRedirectInfo.of("보드가 수정되었습니다.", "/butter.do?id=" + id);
    }

    @RequestMapping(value = "/maker", method = RequestMethod.GET)
    public List<UserDto> getUsers(@RequestParam(value = "q") String search, Model model) {
        return userService.getUsers(containsNameOrEmail(search), projectionForBasic);
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public ResultRedirectInfo deleteButter(@PathVariable("id") Long id) {
        butterService.remove(id);
        return ResultRedirectInfo.of("버터를 삭제하였습니다.", "/butter-list.do");
    }
}
