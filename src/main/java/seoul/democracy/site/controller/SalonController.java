package seoul.democracy.site.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.issue.service.CategoryService;
import seoul.democracy.issue.service.IssueService;
import seoul.democracy.salon.domain.SalonSort;
import seoul.democracy.salon.dto.SalonDto;
import seoul.democracy.salon.predicate.SalonPredicate;
import seoul.democracy.salon.service.SalonService;
import seoul.democracy.user.utils.UserUtils;
import seoul.democracy.issue.domain.Issue.Status;

import static seoul.democracy.salon.predicate.SalonPredicate.*;

import java.util.List;

import seoul.democracy.issue.predicate.CategoryPredicate;
import seoul.democracy.issue.dto.CategoryDto;

@Controller
public class SalonController {

    private final SalonService salonService;
    private final IssueService issueService;
    private final CategoryService categoryService;

    @Autowired
    public SalonController(SalonService salonService, IssueService issueService, CategoryService categoryService) {
        this.salonService = salonService;
        this.issueService = issueService;
        this.categoryService = categoryService;
    }

    @RequestMapping(value = "/content-list.do", method = RequestMethod.GET)
    public String salonList(@RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "category", required = false) String category, Model model) {

        List<SalonDto> salons = salonService.getSalonsWithIssueTags(
                SalonPredicate.predicateForSiteList(search, category), SalonDto.projectionForSiteList);

        List<CategoryDto> categories = salonService.getAllSalonCategories(SalonPredicate.distinctSalonCategories(),
                CategoryDto.projectionForFilter);
        model.addAttribute("categories", categories);
        model.addAttribute("category", category);
        model.addAttribute("salons", salons);

        return "/site/salon/list";
    }

    @RequestMapping(value = "/content.do", method = RequestMethod.GET)
    public String salon(@RequestParam("id") Long id, Model model) {
        SalonDto salonDto = salonService.getSalonSiteDetail(SalonPredicate.equalIdAndStatus(id, Status.OPEN),
                SalonDto.projectionForSiteDetail);
        if (salonDto == null)
            throw new NotFoundException("해당 내용을 찾을 수 없습니다.");
        List<SalonDto> salons = salonService.getSalonsWithIssueTags(SalonPredicate.equalStatus(Status.OPEN),
                SalonDto.projectionForSiteList);
        issueService.increaseViewCount(salonDto.getStatsId());
        model.addAttribute("salon", salonDto);
        model.addAttribute("salons", salons);
        return "/site/salon/detail";
    }

    @RequestMapping(value = "/content-new.do", method = RequestMethod.GET)
    public String newSalon(Model model) {

        List<CategoryDto> categories = categoryService.getCategories(CategoryPredicate.enabled(),
                CategoryDto.projectionForFilter);
        model.addAttribute("categories", categories);
        return "/site/salon/new";
    }

    @RequestMapping(value = "/content-edit.do", method = RequestMethod.GET)
    public String editSalon(@RequestParam("id") Long id, Model model) {

        SalonDto salonDto = salonService.getSalonWithIssueTags(predicateForEdit(id, UserUtils.getUserId()),
                SalonDto.projectionForSiteEdit);
        if (salonDto == null)
            throw new NotFoundException("해당 내용을 찾을 수 없습니다.");

        model.addAttribute("editDto", salonDto);
        List<CategoryDto> categories = categoryService.getCategories(CategoryPredicate.enabled(),
                CategoryDto.projectionForFilter);
        model.addAttribute("categories", categories);
        return "/site/salon/edit";
    }

    @RequestMapping(value = "/shared/{id}", method = RequestMethod.GET)
    public String shared(@PathVariable("id") Long id, Model model) {
        salonService.shared(id);
        return "/site/salon/shared";
    }
}
