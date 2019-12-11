package seoul.democracy.admin.restcontroller;

import com.mysema.query.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.*;

import seoul.democracy.butter.dto.ButterDto;
import seoul.democracy.butter.predicate.ButterPredicate;
import seoul.democracy.butter.service.ButterService;
import seoul.democracy.common.dto.ResultInfo;
import seoul.democracy.issue.domain.IssueGroup;
import seoul.democracy.issue.service.IssueService;
import seoul.democracy.salon.dto.SalonDto;
import seoul.democracy.salon.predicate.SalonPredicate;
import seoul.democracy.salon.service.SalonService;

@RestController
@RequestMapping("/admin/ajax/issue")
public class AdminSalonAjaxController {

    private final ButterService butterService;
    private final SalonService salonService;
    private final IssueService issueService;

    @Autowired
    public AdminSalonAjaxController(ButterService butterService, SalonService salonService, IssueService issueService) {
        this.butterService = butterService;
        this.salonService = salonService;
        this.issueService = issueService;
    }

    @RequestMapping(value = "/salons", method = RequestMethod.GET)
    public Page<SalonDto> getSalons(@RequestParam(value = "search") String search,
            @RequestParam(value = "category", required = false) String category, @PageableDefault Pageable pageable) {
        Predicate predicate = SalonPredicate.predicateForAdminList(search, category);
        return salonService.getSalons(predicate, pageable, SalonDto.projectionForSiteList);
    }

    @RequestMapping(value = "/butters", method = RequestMethod.GET)
    public Page<ButterDto> getButters(@RequestParam(value = "search") String search,
            @RequestParam(value = "category", required = false) String category, @PageableDefault Pageable pageable) {
        Predicate predicate = ButterPredicate.predicateForAdminList(IssueGroup.USER, search, category);
        return butterService.getButters(predicate, pageable, ButterDto.projectionForSiteList);
    }

    @RequestMapping(value = "/{id}/closed", method = RequestMethod.PATCH)
    public ResultInfo closedProposal(@PathVariable("id") Long id) {
        issueService.closed(id);

        return ResultInfo.of("비공개 상태입니다.");
    }

    @RequestMapping(value = "/{id}/open", method = RequestMethod.PATCH)
    public ResultInfo openProposal(@PathVariable("id") Long id) {
        issueService.open(id);

        return ResultInfo.of("공개 상태입니다.");
    }
}
