package seoul.democracy.site.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import seoul.democracy.opinion.dto.OpinionDto;
import seoul.democracy.opinion.service.OpinionService;
import seoul.democracy.proposal.dto.ProposalDto;
import seoul.democracy.proposal.service.ProposalService;
import seoul.democracy.user.dto.UserDto;
import seoul.democracy.user.service.UserService;
import seoul.democracy.user.utils.UserUtils;

import static org.springframework.data.domain.Sort.Direction.DESC;
import static seoul.democracy.opinion.dto.OpinionDto.projectionForMypage;
import static seoul.democracy.opinion.predicate.OpinionPredicate.predicateForMypageDebateOpinion;
import static seoul.democracy.opinion.predicate.OpinionPredicate.predicateForMypageProposalOpinion;
import static seoul.democracy.proposal.dto.ProposalDto.projectionForMypageProposal;
import static seoul.democracy.proposal.predicate.ProposalPredicate.predicateForMypageProposal;
import static seoul.democracy.user.dto.UserDto.projectionForBasic;
import static seoul.democracy.user.predicate.UserPredicate.equalId;

@Controller
@RequestMapping("/mypage")
public class MyPageController {

    private final OpinionService opinionService;
    private final ProposalService proposalService;
    private final UserService userService;

    @Autowired
    public MyPageController(OpinionService opinionService,
                            ProposalService proposalService,
                            UserService userService) {
        this.opinionService = opinionService;
        this.proposalService = proposalService;
        this.userService = userService;
    }

    /**
     * 내 정보 수정
     */
    @RequestMapping(value = "/info.do", method = RequestMethod.GET)
    public String info(Model model) {
        UserDto userDto = userService.getUser(equalId(UserUtils.getUserId()), projectionForBasic);
        model.addAttribute("me", userDto);

        return userDto.getProvider().equals("email") ? "/site/mypage/info" : "/site/mypage/info-social";
    }

    @RequestMapping(value = "/change-password.do", method = RequestMethod.GET)
    public String changePassword() {
        return "/site/mypage/change-password";
    }

    /**
     * 나의 제안 활동
     */
    @RequestMapping(value = "/proposal.do", method = RequestMethod.GET)
    public String proposal(@RequestParam(value = "search", required = false) String search,
                           @PageableDefault(sort = "createdDate", direction = DESC) Pageable pageable,
                           Model model) {
        Page<ProposalDto> proposals = proposalService.getProposalsWithIssueTags(predicateForMypageProposal(UserUtils.getUserId(), search), pageable, projectionForMypageProposal);
        model.addAttribute("proposals", proposals);

        model.addAttribute("search", search);

        return "/site/mypage/proposal";
    }

    /**
     * 나의 투표 활동
     */
    @RequestMapping(value = "/vote.do", method = RequestMethod.GET)
    public String debateOpinion(@RequestParam(value = "search", required = false) String search,
                                @PageableDefault(sort = "createdDate", direction = DESC) Pageable pageable,
                                Model model) {
        Page<OpinionDto> opinions = opinionService.getOpinions(predicateForMypageDebateOpinion(UserUtils.getUserId(), search), pageable, projectionForMypage);
        model.addAttribute("opinions", opinions);

        model.addAttribute("search", search);

        return "/site/mypage/debate-opinion";
    }

    /**
     * 나의 의견 활동
     */
    @RequestMapping(value = "/opinion.do", method = RequestMethod.GET)
    public String proposalOpinion(@RequestParam(value = "search", required = false) String search,
                                  @PageableDefault(sort = "createdDate", direction = DESC) Pageable pageable,
                                  Model model) {

        Page<OpinionDto> opinions = opinionService.getOpinions(predicateForMypageProposalOpinion(UserUtils.getUserId(), search), pageable, projectionForMypage);
        model.addAttribute("opinions", opinions);

        model.addAttribute("search", search);

        return "/site/mypage/proposal-opinion";
    }
}
