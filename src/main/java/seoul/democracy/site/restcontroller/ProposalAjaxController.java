package seoul.democracy.site.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import seoul.democracy.common.dto.ResultInfo;
import seoul.democracy.common.dto.ResultRedirectInfo;
import seoul.democracy.proposal.domain.Proposal;
import seoul.democracy.proposal.dto.ProposalCreateDto;
import seoul.democracy.proposal.dto.ProposalUpdateDto;
import seoul.democracy.proposal.service.ProposalService;
import seoul.democracy.issue.service.IssueTagService;
import seoul.democracy.issue.dto.IssueTagDto;

import static seoul.democracy.issue.predicate.IssueTagPredicate.containsName;

import java.util.List;

import javax.validation.Valid;

@RestController
@RequestMapping("/ajax/mypage")
public class ProposalAjaxController {

    private final ProposalService proposalService;
    private final IssueTagService issueTagService;

    @Autowired
    public ProposalAjaxController(ProposalService proposalService,
                                  IssueTagService issueTagService) {
        this.proposalService = proposalService;
        this.issueTagService = issueTagService;
    }

    @RequestMapping(value = "/proposals", method = RequestMethod.POST)
    public ResultRedirectInfo newProposal(@RequestBody @Valid ProposalCreateDto createDto) throws Exception {
        Proposal proposal = proposalService.create(createDto);

        return ResultRedirectInfo.of("아이디어를 등록하였습니다.", "/proposal.do?id=" + proposal.getId());
    }

    @RequestMapping(value = "/proposals/{id}", method = RequestMethod.PUT)
    public ResultInfo editProposal(@PathVariable("id") Long id,
                                   @RequestBody @Valid ProposalUpdateDto updateDto) {
        proposalService.update(updateDto);

        return ResultInfo.of("아이디어를 수정하였습니다.");
    }

    @RequestMapping(value = "/proposals/{id}", method = RequestMethod.DELETE)
    public ResultInfo deleteProposal(@PathVariable("id") Long id) {
        proposalService.delete(id);

        return ResultInfo.of("아이디어를 삭제하였습니다.");
    }

    @RequestMapping(value = "/proposals/{id}/selectLike", method = RequestMethod.PUT)
    public ResultInfo selectLikeProposal(@PathVariable("id") Long id) {
        proposalService.selectLike(id);

        return ResultInfo.of("공감하였습니다.");
    }

    @RequestMapping(value = "/proposals/{id}/deselectLike", method = RequestMethod.PUT)
    public ResultInfo deselectLikeProposal(@PathVariable("id") Long id) {
        proposalService.deselectLike(id);

        return ResultInfo.of("공감해제하였습니다.");
    }

    @RequestMapping(value = "/issuetags", method = RequestMethod.GET)
    public List<IssueTagDto> tagProposal(@RequestParam("q") String search,
                                         Model model) {
        return issueTagService.getIssueTags(containsName(search));
    }
}
