package seoul.democracy.admin.restcontroller;

import com.mysema.query.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.*;
import seoul.democracy.common.dto.ResultInfo;
import seoul.democracy.proposal.domain.Proposal;
import seoul.democracy.proposal.domain.ProposalType;
import seoul.democracy.proposal.dto.*;
import seoul.democracy.proposal.service.ProposalService;
import seoul.democracy.user.domain.User;
import seoul.democracy.user.utils.UserUtils;

import javax.validation.Valid;

import static seoul.democracy.proposal.dto.ProposalDto.*;
import static seoul.democracy.proposal.predicate.ProposalPredicate.*;

@RestController
@RequestMapping("/admin/ajax/issue/proposals")
public class AdminProposalAjaxController {

    private final ProposalService proposalService;

    @Autowired
    public AdminProposalAjaxController(ProposalService proposalService) {
        this.proposalService = proposalService;
    }

    @RequestMapping(method = RequestMethod.GET)
    public Page<ProposalDto> getProposals(@RequestParam(value = "search") String search,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "process", required = false) Proposal.Process process,
            @RequestParam(value = "proposalType", required = false) ProposalType proposalType,
            @PageableDefault Pageable pageable) {
        Predicate predicate = predicateForAdminList(search, category, process, proposalType);
        return proposalService.getProposals(predicate, pageable, projectionForAdminList);
    }

    /**
     * 연관제안에서 리스트 가져오기에 사용
     */
    @RequestMapping(value = "/select", method = RequestMethod.GET)
    public Page<ProposalDto> getProposalsForSelect(@RequestParam(value = "search", required = false) String search,
            @PageableDefault Pageable pageable) {
        return proposalService.getProposals(predicateForRelationSelect(search), pageable, projectionForAdminSelect);
    }

    @RequestMapping(value = "/{proposalId}/category", method = RequestMethod.PATCH)
    public ResultInfo updateCategory(@PathVariable("proposalId") Long proposalId,
            @RequestBody @Valid ProposalCategoryUpdateDto updateDto) {

        proposalService.updateCategory(updateDto);

        return ResultInfo.of("분류를 업데이트 하였습니다.");
    }

    @RequestMapping(value = "/{proposalId}/proposalType", method = RequestMethod.PATCH)
    public ResultInfo updateProposalType(@PathVariable("proposalId") Long proposalId,
            @RequestBody @Valid ProposalTypeUpdateDto updateDto) {

        proposalService.updateProposalType(updateDto);

        return ResultInfo.of("타입을 업데이트 하였습니다.");
    }

    @RequestMapping(value = "/{proposalId}/closed", method = RequestMethod.PATCH)
    public ResultInfo closedProposal(@PathVariable("proposalId") Long proposalId) {
        proposalService.closed(proposalId);

        return ResultInfo.of("비공개 상태입니다.");
    }

    @RequestMapping(value = "/{proposalId}/open", method = RequestMethod.PATCH)
    public ResultInfo openProposal(@PathVariable("proposalId") Long proposalId) {
        proposalService.open(proposalId);

        return ResultInfo.of("공개 상태입니다.");
    }

    @RequestMapping(value = "/{proposalId}/adminComment", method = RequestMethod.PATCH)
    public ResultInfo adminComment(@PathVariable("proposalId") Long proposalId,
            @RequestBody @Valid ProposalAdminCommentEditDto editDto) {

        proposalService.editAdminComment(editDto);

        return ResultInfo.of("관리자 댓글을 수정하였습니다.");
    }

    @RequestMapping(value = "/{proposalId}/assignManager", method = RequestMethod.PATCH)
    public ProposalDto assignManager(@PathVariable("proposalId") Long proposalId,
            @RequestBody @Valid ProposalManagerAssignDto assignDto) {

        Proposal proposal = proposalService.assignManager(assignDto);

        return proposalService.getProposal(equalId(proposal.getId()), projectionForAssignManager);
    }

    @RequestMapping(value = "/{proposalId}/managerComment", method = RequestMethod.PATCH)
    public ResultInfo managerComment(@PathVariable("proposalId") Long proposalId,
            @RequestBody @Valid ProposalManagerCommentEditDto editDto) {

        proposalService.editManagerComment(editDto);

        return ResultInfo.of("담당자 답변을 수정하였습니다.");
    }
}
