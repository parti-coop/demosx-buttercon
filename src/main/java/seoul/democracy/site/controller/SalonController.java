package seoul.democracy.site.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.issue.service.IssueService;
import seoul.democracy.salon.domain.SalonSort;
import seoul.democracy.salon.dto.SalonDto;
import seoul.democracy.salon.dto.SalonEditDto;
import seoul.democracy.salon.predicate.SalonPredicate;
import seoul.democracy.salon.service.SalonService;
import seoul.democracy.user.utils.UserUtils;

import static seoul.democracy.issue.domain.Issue.Status.OPEN;
import static seoul.democracy.salon.dto.SalonDto.*;
import static seoul.democracy.salon.predicate.SalonPredicate.*;

@Controller
public class SalonController {

    private final SalonService salonService;
    private final IssueService issueService;

    @Autowired
    public SalonController(SalonService salonService, IssueService issueService) {
        this.salonService = salonService;
        this.issueService = issueService;
    }

    @RequestMapping(value = "/salon-list.do", method = RequestMethod.GET)
    public String salonList(@RequestParam(value = "sort", defaultValue = "latest") SalonSort sort,
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "page", defaultValue = "1") int page, Model model) {
        Pageable pageable = new PageRequest(page - 1, 10, sort.getSort());
        Page<SalonDto> salons = salonService.getSalonsWithIssueTags(SalonPredicate.predicateForSiteList(search),
                pageable, SalonDto.projectionForSiteList);
        model.addAttribute("page", salons);
        model.addAttribute("sort", sort);
        model.addAttribute("search", search);
        return "/site/salon/list";
    }

    @RequestMapping(value = "/salon.do", method = RequestMethod.GET)
    public String salon(@RequestParam("id") Long id, Model model) {
        SalonDto salonDto = salonService.getSalonSiteDetail(SalonPredicate.equalIdAndStatus(id, OPEN),
                SalonDto.projectionForSiteDetail);
        if (salonDto == null)
            throw new NotFoundException("해당 내용을 찾을 수 없습니다.");
        model.addAttribute("salon", salonDto);
        issueService.increaseViewCount(salonDto.getStatsId());
        return "/site/salon/detail";
    }

    @RequestMapping(value = "/salon-new.do", method = RequestMethod.GET)
    public String newSalon(Model model) {
        return "/site/salon/new";
    }

    @RequestMapping(value = "/salon-edit.do", method = RequestMethod.GET)
    public String editSalon(@RequestParam("id") Long id, Model model) {

        SalonDto salonDto = salonService.getSalonWithIssueTags(predicateForEdit(id, UserUtils.getUserId()),
                projectionForSiteEdit);
        if (salonDto == null)
            throw new NotFoundException("해당 내용을 찾을 수 없습니다.");

        SalonEditDto updateDto = SalonEditDto.of(salonDto.getId(), salonDto.getTitle(), salonDto.getContent(),
                salonDto.getImage(), salonDto.getIssueTags());
        model.addAttribute("editDto", updateDto);
        return "/site/salon/edit";
    }

    @RequestMapping(value = "/shared", method = RequestMethod.GET)
    public String shared(@RequestParam("id") Long id, Model model) {
        salonService.shared(id);
        return "/site/salon/shared";
    }
}
