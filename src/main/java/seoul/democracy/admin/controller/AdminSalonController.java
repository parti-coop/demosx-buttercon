package seoul.democracy.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import seoul.democracy.butter.dto.ButterDto;
import seoul.democracy.butter.predicate.ButterPredicate;
import seoul.democracy.butter.service.ButterService;
import seoul.democracy.issue.dto.CategoryDto;
import seoul.democracy.issue.service.CategoryService;
import seoul.democracy.salon.dto.SalonDto;
import seoul.democracy.salon.predicate.SalonPredicate;
import seoul.democracy.salon.service.SalonService;

import java.util.List;

import static seoul.democracy.issue.dto.CategoryDto.projectionForFilter;
import static seoul.democracy.issue.predicate.CategoryPredicate.enabled;

@Controller
@RequestMapping("/admin/issue")
public class AdminSalonController {

    private final CategoryService categoryService;
    private final ButterService butterService;
    private final SalonService salonService;

    @Autowired
    public AdminSalonController(CategoryService categoryService, ButterService butterService,
            SalonService salonService) {
        this.categoryService = categoryService;
        this.butterService = butterService;
        this.salonService = salonService;
    }

    @ModelAttribute("categories")
    public List<CategoryDto> getCategories() {
        return categoryService.getCategories(enabled(), projectionForFilter);
    }

    @RequestMapping(value = "/butter.do", method = RequestMethod.GET)
    public String butterList() {
        return "/admin/salon/butterlist";
    }

    @RequestMapping(value = "/salon.do", method = RequestMethod.GET)
    public String salonList() {
        return "/admin/salon/salonlist";
    }

    @RequestMapping(value = "/butter-detail.do", method = RequestMethod.GET)
    public String butterDetail(@RequestParam("id") Long id, Model model) {
        ButterDto dto = butterService.getButter(ButterPredicate.equalId(id), ButterDto.projection);
        model.addAttribute("dto", dto);
        return "/admin/salon/butterdetail";
    }

    @RequestMapping(value = "/salon-detail.do", method = RequestMethod.GET)
    public String salonDetail(@RequestParam("id") Long id, Model model) {
        SalonDto dto = salonService.getSalon(SalonPredicate.equalId(id), SalonDto.projection);
        model.addAttribute("dto", dto);
        return "/admin/salon/salondetail";
    }
}
