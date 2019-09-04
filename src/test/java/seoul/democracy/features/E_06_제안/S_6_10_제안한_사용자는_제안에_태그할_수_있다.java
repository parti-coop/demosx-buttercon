package seoul.democracy.features.E_06_제안;

import org.junit.Before;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.security.test.context.support.WithUserDetails;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import seoul.democracy.issue.dto.IssueTagsAddDto;
import seoul.democracy.issue.service.IssueTagService;
import seoul.democracy.proposal.domain.Proposal;
import seoul.democracy.proposal.dto.ProposalCreateDto;
import seoul.democracy.proposal.dto.ProposalDto;
import seoul.democracy.proposal.service.ProposalService;

import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static org.hamcrest.Matchers.*;
import static org.junit.Assert.assertThat;
import static seoul.democracy.proposal.dto.ProposalDto.projection;
import static seoul.democracy.proposal.predicate.ProposalPredicate.equalId;

/**
 * epic : 6. 제안
 * story : 6.10 제안한 사용자는 제안에 태그할 수 있다
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {
    "file:src/main/resources/egovframework/spring/context-*.xml",
    "file:src/test/resources/egovframework/spring-test/context-*.xml",
    "file:src/main/webapp/WEB-INF/config/egovframework/springmvc/egov-com-*.xml"
})
@Sql({"file:src/test/resources/sql/test-data.sql"})
@Transactional
@Rollback
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@ActiveProfiles("test")
public class S_6_10_제안한_사용자는_제안에_태그할_수_있다 {

    private final static DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH-mm");
    private final static String ip = "127.0.0.1";

    @Autowired
    private ProposalService proposalService;
    @Autowired
    private IssueTagService issueTagService;


    @Before
    public void setUp() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setRemoteAddr(ip);
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));
    }

    /**
     * 10. 제안한 사용자는 제안에 태그할 수 있다
     */
    @Test
    @WithUserDetails("user1@googl.co.kr")
    public void T_10_제안한_사용자는_제안에_태그할_수_있다() {
        ProposalCreateDto createDto = ProposalCreateDto.of("제안합니다.", "제안내용입니다.", "환경");
        Proposal proposal = proposalService.create(createDto);

        assertThat(proposal.getId(), is(notNullValue()));

        String[] tagNames1 = { "AB","BC","CD","AE", "FE" };
        IssueTagsAddDto issueTagsAddDto1 = IssueTagsAddDto.of(proposal.getId(), tagNames1);
        issueTagService.changeIssueTags(issueTagsAddDto1);

        ProposalDto proposalDto1 = proposalService.getProposalWithTags(equalId(proposal.getId()), projection);
        String[] resultTagNames1 = proposalDto1.getTags()
                                .stream()
                                .map(issueTagDto -> issueTagDto.getName())
                                .toArray(String[]::new);
        assertThat(resultTagNames1, is(Arrays.stream(tagNames1).sorted().toArray(String[]::new)));

        List<String> allTagName = issueTagService.getIssueTags().stream()
                                        .map(issueTagDto -> issueTagDto.getName())
                                        .collect(Collectors.toList());
        assertThat(allTagName, hasItems("AB", "FE"));

        // 다른 제안
        ProposalCreateDto createDto2 = ProposalCreateDto.of("제안합니다.2", "제안내용입니다.2", "환경");
        Proposal proposal2 = proposalService.create(createDto);

        assertThat(proposal2.getId(), is(notNullValue()));

        // 다른 제안에 태깅
        String[] tagNamesX = { "BC","FE" };
        IssueTagsAddDto issueTagsAddDtoX = IssueTagsAddDto.of(proposal.getId(), tagNamesX);
        issueTagService.changeIssueTags(issueTagsAddDtoX);

        // 원래 제안에 태그 변경

        String[] tagNames2 = { "FF","BC","FE","AE" };
        IssueTagsAddDto issueTagsAddDto2 = IssueTagsAddDto.of(proposal.getId(), tagNames2);
        issueTagService.changeIssueTags(issueTagsAddDto2);

        ProposalDto proposalDto2 = proposalService.getProposalWithTags(equalId(proposal.getId()), projection);
        String[] resultTagNames2 = proposalDto2.getTags()
                                .stream()
                                .map(issueTagDto -> issueTagDto.getName())
                                .toArray(String[]::new);
        assertThat(resultTagNames2, is(Arrays.stream(tagNames2).sorted().toArray(String[]::new)));

        allTagName = issueTagService.getIssueTags().stream()
                                        .map(issueTagDto -> issueTagDto.getName())
                                        .collect(Collectors.toList());
        assertThat(allTagName, not(hasItems("AB")));
        assertThat(allTagName, hasItems("FE"));
    }

}
