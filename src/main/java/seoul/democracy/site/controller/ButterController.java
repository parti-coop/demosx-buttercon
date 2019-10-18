package seoul.democracy.site.controller;

import static seoul.democracy.butter.dto.ButterDto.projectionForSiteDetail;
import static seoul.democracy.butter.predicate.ButterPredicate.equalIdAndStatus;
import static seoul.democracy.issue.domain.Issue.Status.OPEN;

import java.util.List;

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
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.debate.dto.DebateCreateDto;
import seoul.democracy.issue.domain.IssueGroup;
import seoul.democracy.issue.service.IssueService;

@Controller
public class ButterController {

    @Autowired
    private ButterService butterService;
    @Autowired
    private IssueService issueService;

    @RequestMapping(value = "/butter-list.do", method = RequestMethod.GET)
    public String butterList(Model model) {
        List<ButterDto> myButters = butterService.getButters(ButterDto.projectionForSiteList, true);
        List<ButterDto> otherButters = butterService.getButters(ButterDto.projectionForSiteList, false);
        model.addAttribute("myButters", myButters);
        model.addAttribute("otherButters", otherButters);
        return "/site/butter/list";
    }

    @RequestMapping(value = "/butter.do", method = RequestMethod.GET)
    public String butter(@RequestParam("id") Long id, Model model) {

        Predicate predicate = equalIdAndStatus(id, OPEN);
        ButterDto butterDto = butterService.getButter(predicate, projectionForSiteDetail, true, true);
        if (butterDto == null)
            throw new NotFoundException("해당 내용을 찾을 수 없습니다.");

        model.addAttribute("debate", butterDto);
        issueService.increaseViewCount(butterDto.getStatsId());
        return "/site/butter/detail";
    }

    @RequestMapping(value = "/butter-new.do", method = RequestMethod.GET)
    public String butterNew(@ModelAttribute("createDto") DebateCreateDto createDto, Model model) {
        model.addAttribute("issueGroup", IssueGroup.USER);
        model.addAttribute("groupText", "버터제안");
        return "/site/butter/new";
    }
}
