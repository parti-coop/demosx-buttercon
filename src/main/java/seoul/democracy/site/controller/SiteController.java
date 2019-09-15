package seoul.democracy.site.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import seoul.democracy.issue.domain.Issue;
import seoul.democracy.proposal.domain.Proposal;
import seoul.democracy.proposal.domain.ProposalType;
import seoul.democracy.proposal.dto.ProposalDto;
import seoul.democracy.proposal.service.ProposalService;

import static seoul.democracy.proposal.dto.ProposalDto.projectionForSiteList;
import static seoul.democracy.proposal.predicate.ProposalPredicate.*;

@Controller
public class SiteController {

    private final ProposalService proposalService;

    private final Pageable pageableByLimit2 = new PageRequest(0, 2, Sort.Direction.DESC, "stats.likeCount");

    private final Pageable pageableByLimit4 = new PageRequest(0, 4, Sort.Direction.DESC, "createdDate");

    private final Pageable pageableByLimit6 = new PageRequest(0, 6, Sort.Direction.DESC, "createdDate");

    @Autowired
    public SiteController(ProposalService proposalService) {
        this.proposalService = proposalService;
    }

    /**
     * home 화면
     */
    @RequestMapping(value = "/index.do", method = RequestMethod.GET)
    public String index(Model model) {
        // 최신글 - 최대 6개 - 제안으로 분류된 것 중 최
        Page<ProposalDto> latest = proposalService.getProposalsWithIssueTags(equalStatus(Issue.Status.OPEN), pageableByLimit6, projectionForSiteList);
        model.addAttribute("latest", latest);

        return "/site/index";
    }

    /**
     * 오픈소스 스태틱 페이지
     */
    @RequestMapping(value = "/intro.do", method = RequestMethod.GET)
    public String intro() {
        return "/site/static/intro";
    }

    /**
     * 개인정보처리방침
     */
    @RequestMapping(value = "/privacy.do", method = RequestMethod.GET)
    public String privacy() {
        return "/site/static/privacy";
    }

    /**
     * 이용약관
     */
    @RequestMapping(value = "/terms.do", method = RequestMethod.GET)
    public String terms() {
        return "/site/static/terms";
    }

    /**
     * 저작권 및 컨텐츠 관련안내
     */
    @RequestMapping(value = "/copyright.do", method = RequestMethod.GET)
    public String copyright() {
        return "/site/static/copyright";
    }

    /**
     * 403
     */
    @RequestMapping(value = "/403.do", method = RequestMethod.GET)
    public String forbidden() {
        return "/site/static/403";
    }

    /**
     * 404
     */
    @RequestMapping(value = "/404.do", method = RequestMethod.GET)
    public String notFound() {
        return "/site/static/404";
    }

    /**
     * 500
     */
    @RequestMapping(value = "/500.do", method = RequestMethod.GET)
    public String error() {
        return "/site/static/500";
    }

    @RequestMapping(value={"/robots.txt", "/robot.txt"})
    @ResponseBody
    public String getRobotsTxt() {
        return "User-agent: *\n" +
               "Disallow: /\n";
    }
}
