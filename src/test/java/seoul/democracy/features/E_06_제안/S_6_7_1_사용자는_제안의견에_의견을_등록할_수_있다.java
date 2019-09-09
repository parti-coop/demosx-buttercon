package seoul.democracy.features.E_06_제안;

import org.junit.Before;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.test.context.support.WithUserDetails;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.opinion.domain.Opinion;
import seoul.democracy.opinion.dto.OpinionDto;
import seoul.democracy.opinion.dto.OpinionUpdateDto;
import seoul.democracy.opinion.dto.ChildOpinionCreateDto;
import seoul.democracy.opinion.service.OpinionService;
import seoul.democracy.proposal.dto.ProposalDto;
import seoul.democracy.proposal.predicate.ProposalPredicate;
import seoul.democracy.proposal.service.ProposalService;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

import com.mysema.query.types.Predicate;

import static org.hamcrest.Matchers.*;
import static org.junit.Assert.assertThat;
import static org.hamcrest.Matchers.notNullValue;
import static seoul.democracy.opinion.dto.OpinionDto.projection;
import static seoul.democracy.opinion.predicate.OpinionPredicate.equalId;
import static seoul.democracy.opinion.predicate.OpinionPredicate.predicateForOpinionList;
import static seoul.democracy.opinion.dto.OpinionDto.projectionForIssueDetail;

/**
 * epic : 6. 제안
 * story : 6.8 사용자는 제안의견을 수정 및 삭제할 수 있다.
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
public class S_6_7_1_사용자는_제안의견에_의견을_등록할_수_있다 {

    private final static String ip = "127.0.0.2";
    private MockHttpServletRequest request;

    @Autowired
    private OpinionService opinionService;

    @Before
    public void setUp() throws Exception {
        request = new MockHttpServletRequest();
        request.setRemoteAddr(ip);
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));
    }

    /**
     * 1. 사용자는 제안의견에 의견을 등록할 수 있다.
     */
    @Test
    @WithUserDetails("user2@googl.co.kr")
    public void T_01_사용자는_본인의견을_수정할_수_있다() {
        Long parentOpinionId = 1L;
        ChildOpinionCreateDto childCreateDto = ChildOpinionCreateDto.of(parentOpinionId, "하위 제안의견 입니다.");
        Opinion chidOpinion = opinionService.createOpinion(childCreateDto);
        assertThat(chidOpinion.getId(), is(notNullValue()));
        System.out.printf("chidOpinion : %d\n", chidOpinion.getId());

        OpinionDto parentOpinionDto = opinionService.getOpinion(equalId(parentOpinionId), projection);

        Pageable pageable = new PageRequest(0, 10);
        Predicate predicateForOpinionList = predicateForOpinionList(parentOpinionDto.getIssue().getId());
        Page<OpinionDto> issueParentOpinionDtos = opinionService.getParentOpinionsWithChildOpinionsAndLiked(predicateForOpinionList, pageable, projectionForIssueDetail);

        issueParentOpinionDtos.forEach(issueParentOpinionDto -> {
            if(parentOpinionDto.getId().equals(issueParentOpinionDto.getId())) {
                List<Long> childOptionIds = issueParentOpinionDto.getChildOpinions().stream().map(childOpinion -> { return childOpinion.getId(); }).collect(Collectors.toList());

                assertThat(childOptionIds, hasItems(chidOpinion.getId()));
            }
        });
    }
}
