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
import seoul.democracy.issue.dto.CategoryDto;
import seoul.democracy.issue.service.CategoryService;
import seoul.democracy.issue.service.IssueService;
import seoul.democracy.proposal.domain.ProposalSort;
import seoul.democracy.proposal.dto.ProposalDto;
import seoul.democracy.proposal.dto.ProposalUpdateDto;
import seoul.democracy.proposal.service.ProposalService;
import seoul.democracy.user.utils.UserUtils;

import java.util.List;

import static seoul.democracy.issue.domain.Issue.Status.OPEN;
import static seoul.democracy.issue.dto.CategoryDto.projectionForFilter;
import static seoul.democracy.issue.predicate.CategoryPredicate.enabled;
import static seoul.democracy.proposal.dto.ProposalDto.*;
import static seoul.democracy.proposal.predicate.ProposalPredicate.*;

@Controller
public class ProposalController {

    private final ProposalService proposalService;
    private final CategoryService categoryService;
    private final IssueService issueService;

    @Autowired
    public ProposalController(ProposalService proposalService,
                              CategoryService categoryService,
                              IssueService issueService) {
        this.proposalService = proposalService;
        this.categoryService = categoryService;
        this.issueService = issueService;
    }

    @RequestMapping(value = "/proposal-list.do", method = RequestMethod.GET)
    public String proposalList(@RequestParam(value = "category", required = false) String category,
                               @RequestParam(value = "sort", defaultValue = "latest") ProposalSort sort,
                               @RequestParam(value = "search", required = false) String search,
                               @RequestParam(value = "page", defaultValue = "1") int page,
                               Model model) {

        Pageable pageable = new PageRequest(page - 1, 10, sort.getSort());
        Page<ProposalDto> proposals = proposalService.getProposals(predicateForSiteList(search, category), pageable, projectionForSiteList);
        model.addAttribute("page", proposals);

        List<CategoryDto> categories = categoryService.getCategories(enabled(), projectionForFilter);
        model.addAttribute("categories", categories);

        model.addAttribute("sort", sort);
        model.addAttribute("category", category);
        model.addAttribute("search", search);

        return "/site/proposal/list";
    }

    @RequestMapping(value = "/proposal.do", method = RequestMethod.GET)
    public String proposal(@RequestParam("id") Long id,
                           Model model) {
        ProposalDto proposalDto = proposalService.getProposalWithLiked(equalIdAndStatus(id, OPEN), projectionForSiteDetail);
        if (proposalDto == null) throw new NotFoundException("해당 내용을 찾을 수 없습니다.");

        model.addAttribute("proposal", proposalDto);

        issueService.increaseViewCount(proposalDto.getStatsId());

        return "/site/proposal/detail";
    }

    @RequestMapping(value = "/new-proposal.do", method = RequestMethod.GET)
    public String newProposal(Model model) {

        List<CategoryDto> categories = categoryService.getCategories(enabled(), projectionForFilter);
        model.addAttribute("categories", categories);

        return "/site/proposal/new";
    }

    @RequestMapping(value = "/edit-proposal.do", method = RequestMethod.GET)
    public String editProposal(@RequestParam("id") Long id,
                               Model model) {

        ProposalDto proposalDto = proposalService.getProposal(predicateForEdit(id, UserUtils.getUserId()), projectionForSiteEdit);
        if (proposalDto == null) throw new NotFoundException("해당 내용을 찾을 수 없습니다.");

        ProposalUpdateDto updateDto = ProposalUpdateDto.of(proposalDto.getId(), proposalDto.getTitle(), proposalDto.getContent());
        model.addAttribute("updateDto", updateDto);

        return "/site/proposal/edit";
    }
}
