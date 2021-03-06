package seoul.democracy.site.controller;

import static seoul.democracy.butter.dto.ButterDto.projectionForSiteDetail;
import static seoul.democracy.butter.predicate.ButterPredicate.equalIdAndStatus;
import static seoul.democracy.issue.domain.Issue.Status.OPEN;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.util.StringUtils;
import com.mysema.query.types.Predicate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import seoul.democracy.butter.dto.ButterDto;
import seoul.democracy.butter.service.ButterService;
import seoul.democracy.butter.service.MarkdownService;
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.debate.dto.DebateCreateDto;
import seoul.democracy.history.dto.IssueHistoryDto;
import seoul.democracy.history.predicate.IssueHistoryPredicate;
import seoul.democracy.history.service.IssueHistoryService;
import seoul.democracy.issue.service.IssueService;
import seoul.democracy.user.dto.UserDto;
import seoul.democracy.user.utils.UserUtils;

@Controller
public class ButterController {

    @Autowired
    private ButterService butterService;
    @Autowired
    private IssueService issueService;
    @Autowired
    private IssueHistoryService issueHistoryService;
    @Autowired
    private MarkdownService markdownService;

    @RequestMapping(value = "/butter-list.do", method = RequestMethod.GET)
    public String butterList(Model model) {
        List<ButterDto> otherButters = null;
        List<ButterDto> allButters = butterService.getButters(ButterDto.projectionForSiteList);
        if (UserUtils.getLoginUser() != null) {
            List<ButterDto> myButters = butterService.getButtersMine(ButterDto.projectionForSiteListMine);
            List<Long> myButterIds = myButters.stream().map(ButterDto::getId).collect(Collectors.toList());
            otherButters = allButters.stream().filter(b -> !myButterIds.contains(b.getId()))
                    .collect(Collectors.toList());
            model.addAttribute("myButters", myButters);
        } else {
            otherButters = allButters;
        }
        model.addAttribute("otherButters", otherButters);
        return "/site/butter/list";
    }

    @RequestMapping(value = "/butter.do", method = RequestMethod.GET)
    public String butter(@RequestParam("id") Long id, @RequestParam(value = "user", required = false) String user,
            Model model) {

        Predicate predicate = equalIdAndStatus(id, OPEN);
        ButterDto butterDto = butterService.getButter(predicate, projectionForSiteDetail);
        if (butterDto == null)
            throw new NotFoundException("해당 내용을 찾을 수 없습니다.");

        List<IssueHistoryDto> histories = issueHistoryService.getHistories(IssueHistoryPredicate.predicateForSite(id),
                IssueHistoryDto.projectionForSite);
        List<UserDto> contributors = histories.stream().map(IssueHistoryDto::getCreatedBy).distinct()
                .collect(Collectors.toList());
        issueService.increaseViewCount(butterDto.getStatsId());
        model.addAttribute("butter", butterDto);
        if (StringUtils.hasText(user)) {
            model.addAttribute("user", user);
        }
        model.addAttribute("histories", histories);
        model.addAttribute("contributors", contributors);

        List<ButterDto> allButters = butterService.getButters(ButterDto.projectionForSiteList).stream()
                .filter(b -> !b.getId().equals(butterDto.getId())).collect(Collectors.toList());

        List<ButterDto> otherButters = null;
        if (UserUtils.getLoginUser() != null) {
            List<ButterDto> myButters = butterService.getButtersMine(ButterDto.projectionForSiteListMine);
            List<Long> myButterIds = myButters.stream().map(ButterDto::getId).collect(Collectors.toList());
            otherButters = allButters.stream().filter(b -> !myButterIds.contains(b.getId()))
                    .collect(Collectors.toList());
            myButters = myButters.stream().filter(b -> !b.getId().equals(butterDto.getId()))
                    .collect(Collectors.toList());
            model.addAttribute("myButters", myButters);
        } else {
            otherButters = allButters;
        }
        Map<String, String> res = markdownService.parseHtml(butterDto.getContent());
        String html = res.get("html").replaceAll("(#[_a-zA-Z0-9ㄱ-ㅎ가-힣]*)", "<b class='tag'>$1</b>");
        String toc = res.get("toc").replaceAll("([>\\s])(#[_a-zA-Z0-9ㄱ-ㅎ가-힣]*)", "$1<b class='tag'>$2</b>");
        model.addAttribute("toc", toc);
        model.addAttribute("html", html);
        model.addAttribute("otherButters", otherButters);
        return "/site/butter/detail";
    }

    @RequestMapping(value = "/butter-edit.do", method = RequestMethod.GET)
    public String butterEdit(@RequestParam("id") Long id, Model model) {
        Predicate predicate = equalIdAndStatus(id, OPEN);
        ButterDto ButterDto = butterService.getButter(predicate, projectionForSiteDetail);
        IssueHistoryDto recentHistory = issueHistoryService.getHistory(IssueHistoryPredicate.byIssueId(id),
                IssueHistoryDto.projectionForSite);
        if (ButterDto == null)
            throw new NotFoundException("해당 내용을 찾을 수 없습니다.");
        model.addAttribute("butter", ButterDto);
        model.addAttribute("recentHistory", recentHistory);
        if (ButterDto.isMaker()) {
            return "/site/butter/edit-maker";
        }
        return "/site/butter/edit-user";
    }

    @RequestMapping(value = "/butter-history.do", method = RequestMethod.GET)
    public String butterHistory(@RequestParam("id") Long id, Model model) {
        IssueHistoryDto after = issueHistoryService.getHistory(IssueHistoryPredicate.equalId(id),
                IssueHistoryDto.projection);
        Long issueId = after.getIssue().getId();
        IssueHistoryDto before = issueHistoryService.getHistory(IssueHistoryPredicate.justBefore(id, issueId),
                IssueHistoryDto.projectionForSite);
        model.addAttribute("before", before);
        model.addAttribute("after", after);
        return "/site/butter/history";
    }

    @RequestMapping(value = "/butter-conflict.do", method = RequestMethod.GET)
    public String butterHistory(@RequestParam("beforeId") Long beforeId, @RequestParam("afterId") Long afterId,
            Model model) {
        IssueHistoryDto after = issueHistoryService.getHistory(IssueHistoryPredicate.equalId(afterId),
                IssueHistoryDto.projection);
        IssueHistoryDto before = issueHistoryService.getHistory(IssueHistoryPredicate.equalId(beforeId),
                IssueHistoryDto.projectionForSite);
        model.addAttribute("before", before);
        model.addAttribute("after", after);
        return "/site/butter/history-conflict";
    }

    @RequestMapping(value = "/butter-new.do", method = RequestMethod.GET)
    public String butterNew(@ModelAttribute("createDto") DebateCreateDto createDto, Model model) {
        model.addAttribute("myname", UserUtils.getLoginUser().getName());
        model.addAttribute("myid", UserUtils.getLoginUser().getId());
        return "/site/butter/new";
    }
}
