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
import seoul.democracy.proposal.dto.ProposalDto;
import seoul.democracy.proposal.service.ProposalService;

import static seoul.democracy.proposal.dto.ProposalDto.projectionForSiteList;
import static seoul.democracy.proposal.predicate.ProposalPredicate.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

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
        Page<ProposalDto> latest = proposalService.getProposalsWithIssueTags(equalStatus(Issue.Status.OPEN),
                pageableByLimit6, projectionForSiteList);
        model.addAttribute("latest", latest);

        return "/site/index";
    }

    /**
     * 오픈소스 스태틱 페이지
     */
    @RequestMapping(value = "/intro.do", method = RequestMethod.GET)
    public String intro(Model model) {
        List<HashMap<String, String>> interviews = new ArrayList<>();
        interviews.add(new HashMap<String, String>() {{
            put("name", "노유진");
            put("org", "위커넥트 디렉터");
            put("body", "일과 삶 둘 중 하나를 포기하지 않고 나다울 수 있는  다양한 선택지가 모두의 손에 쥐어지기를 기대합니다.");
        }});
        interviews.add(new HashMap<String, String>() {{
            put("name", "신나라");
            put("org", "건국대학교 상담전문교수");
            put("body", "청년들의 체계적인 건강 관리의 필요성이 대두되고 있습니다. 정신건강정책이 사회적 아젠다로 다뤄질 수 있는 기회가 될 것으로 기대합니다.");
        }});
        interviews.add(new HashMap<String, String>() {{
            put("name", "김지수");
            put("org", "빠띠 민주주의 활동가");
            put("body", "나의 경험으로 시작해, 세대의 경험을 모아내는 것. 우리 삶의 원칙이나 규율을 우리가 만드는 것. 함께 목소리를 모으고 행동하는 값진 경험이 우리 안에 남길 기대합니다.");
        }});
        interviews.add(new HashMap<String, String>() {{
            put("name", "정보경");
            put("org", "리워크 대표 플레이어");
            put("body", "청년 전쟁의 중심에서 영역파괴왕을 꿈꾼다.");
        }});
        interviews.add(new HashMap<String, String>() {{
            put("name", "허지용");
            put("org", "루트임팩트 디웰 커뮤니티 디벨로퍼");
            put("body", "우리의 문제는 우리가 제일 잘 알고, 그래서 우리가 가장 잘 해결할 수 있다고 믿습니다. 그리고 우리가 만드는 현재가 누군가에게 보다 나은 미래가 될 수 있기를 기대합니다.");
        }});
        interviews.add(new HashMap<String, String>() {{
            put("name", "윤이나");
            put("org", "<미쓰윤의 알바일지>, <여자들은 먼저 미래로 간다> 저자");
            put("body", "나는 우리가 세상을 직접 바꾸기를 원한다. 지금, 바로 여기에서부터.");
        }});
        interviews.add(new HashMap<String, String>() {{
            put("name", "서승희");
            put("org", "한국사이버성폭력대응센터 부대표");
            put("body", "정책을 만든다, 이렇게만 말하면 너무나도 어렵고 크게 느껴집니다. 하지만 내 삶의 어려움과 불편함에 노력을 통한 전문성 한 스푼이면 우리는 어떤 행정관, 국회의원보다도 좋은 정책을 만들어낼 수 있다고 생각합니다.");
        }});
        interviews.add(new HashMap<String, String>() {{
            put("name", "김정현");
            put("org", "뉴블랙 대표");
            put("body", "이런 주제와 방식으로 이야기를 나눌 수 있는 시대가 오고 또 저에게 기회가 주어진 것에 굉장히 놀랍고 또 즐겁습니다. 다양성과 성평등을 기본으로 다양한 주제와  밀레니얼들의 새로운 관점을 통해 모두가 공감하고 고민해볼 수 있는 풍요로운 이야기들이 나왔으면 합니다.");
        }});
        interviews.add(new HashMap<String, String>() {{
            put("name", "홍진아");
            put("org", "빌라선샤인 대표");
            put("body", "이 시대를 살아가고 있는 우리의 경험이 정책을 만들고 미래를 만들어 가는데 필요한 최고의 전문성이라고 생각합니다. '우리-전문가'들이 만들어 갈 우리의 정책들을 기대합니다.");
        }});
        model.addAttribute("interviews", interviews);
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
