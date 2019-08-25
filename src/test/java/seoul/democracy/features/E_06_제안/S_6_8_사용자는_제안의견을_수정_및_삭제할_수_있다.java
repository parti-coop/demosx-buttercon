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
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.opinion.domain.Opinion;
import seoul.democracy.opinion.dto.OpinionDto;
import seoul.democracy.opinion.dto.OpinionUpdateDto;
import seoul.democracy.opinion.service.OpinionService;
import seoul.democracy.proposal.dto.ProposalDto;
import seoul.democracy.proposal.predicate.ProposalPredicate;
import seoul.democracy.proposal.service.ProposalService;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;
import static seoul.democracy.opinion.dto.OpinionDto.projection;
import static seoul.democracy.opinion.predicate.OpinionPredicate.equalId;


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
public class S_6_8_사용자는_제안의견을_수정_및_삭제할_수_있다 {

    private final static DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH-mm");
    private final static String ip = "127.0.0.2";
    private MockHttpServletRequest request;

    @Autowired
    private OpinionService opinionService;

    @Autowired
    private ProposalService proposalService;

    private Long opinionId = 1L;
    private Long deletedOpinionId = 2L;
    private Long blockedOpinionId = 3L;
    private Long notExistsId = 999L;

    private Long multiOpinionId = 31L;

    @Before
    public void setUp() throws Exception {
        request = new MockHttpServletRequest();
        request.setRemoteAddr(ip);
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));
    }

    /**
     * 1. 사용자는 본인의견을 수정할 수 있다.
     */
    @Test
    @WithUserDetails("user1@googl.co.kr")
    public void T_01_사용자는_본인의견을_수정할_수_있다() {
        final String now = LocalDateTime.now().format(dateTimeFormatter);
        OpinionUpdateDto updateDto = OpinionUpdateDto.of(opinionId, "제안의견 수정합니다.");
        Opinion opinion = opinionService.updateOpinion(updateDto);

        OpinionDto opinionDto = opinionService.getOpinion(equalId(opinion.getId()), projection);
        assertThat(opinionDto.getModifiedDate().format(dateTimeFormatter), is(now));
        assertThat(opinionDto.getModifiedBy().getEmail(), is("user1@googl.co.kr"));
        assertThat(opinionDto.getModifiedIp(), is(ip));

        assertThat(opinionDto.getContent(), is(updateDto.getContent()));

        ProposalDto proposalDto = proposalService.getProposal(ProposalPredicate.equalId(opinion.getIssue().getId()), ProposalDto.projection);
        assertThat(proposalDto.getStats().getOpinionCount(), is(1L));
        assertThat(proposalDto.getStats().getApplicantCount(), is(1L));
    }

    /**
     * 2. 사용자는 본인의견을 삭제할 수 있다.
     */
    @Test
    @WithUserDetails("user1@googl.co.kr")
    public void T_02_사용자는_본인의견을_삭제할_수_있다() {
        final String now = LocalDateTime.now().format(dateTimeFormatter);
        Opinion opinion = opinionService.deleteOpinion(opinionId);

        OpinionDto opinionDto = opinionService.getOpinion(equalId(opinion.getId()), projection);
        assertThat(opinionDto.getModifiedDate().format(dateTimeFormatter), is(now));
        assertThat(opinionDto.getModifiedBy().getEmail(), is("user1@googl.co.kr"));
        assertThat(opinionDto.getModifiedIp(), is(ip));

        assertThat(opinionDto.getStatus(), is(Opinion.Status.DELETE));

        ProposalDto proposalDto = proposalService.getProposal(ProposalPredicate.equalId(opinion.getIssue().getId()), ProposalDto.projection);
        assertThat(proposalDto.getStats().getOpinionCount(), is(0L));
        assertThat(proposalDto.getStats().getApplicantCount(), is(0L));
    }

    /**
     * 3. 다른 사용자의 의견을 수정할 수 없다.
     */
    @Test(expected = AccessDeniedException.class)
    @WithUserDetails("user2@googl.co.kr")
    public void T_03_다른_사용자의_의견을_수정할_수_없다() {
        OpinionUpdateDto updateDto = OpinionUpdateDto.of(opinionId, "다른 사용자가 제안의견을 수정합니다.");
        opinionService.updateOpinion(updateDto);
    }

    /**
     * 4. 다른 사용자의 의견을 삭제할 수 없다.
     */
    @Test(expected = AccessDeniedException.class)
    @WithUserDetails("user2@googl.co.kr")
    public void T_04_다른_사용자의_의견을_삭제할_수_없다() {
        opinionService.deleteOpinion(opinionId);
    }

    /**
     * 5. 없는 의견을 수정할 수 없다.
     */
    @Test(expected = NotFoundException.class)
    @WithUserDetails("user1@googl.co.kr")
    public void T_05_없는_의견을_수정할_수_없다() {
        OpinionUpdateDto updateDto = OpinionUpdateDto.of(notExistsId, "없는 제안의견 수정합니다.");
        opinionService.updateOpinion(updateDto);
    }

    /**
     * 6. 없는 의견을 삭제할 수 없다.
     */
    @Test(expected = NotFoundException.class)
    @WithUserDetails("user1@googl.co.kr")
    public void T_06_없는_의견을_삭제할_수_없다() {
        opinionService.deleteOpinion(notExistsId);
    }

    /**
     * 7. 삭제된 의견을 수정할 수 없다.
     */
    @Test(expected = NotFoundException.class)
    @WithUserDetails("user1@googl.co.kr")
    public void T_07_삭제된_의견을_수정할_수_없다() {
        OpinionUpdateDto updateDto = OpinionUpdateDto.of(deletedOpinionId, "삭제된 의견은 수정할 수 없다.");
        opinionService.updateOpinion(updateDto);
    }

    /**
     * 8. 삭제된 의견을 삭제할 수 없다.
     */
    @Test(expected = NotFoundException.class)
    @WithUserDetails("user1@googl.co.kr")
    public void T_08_삭제된_의견을_삭제할_수_없다() {
        opinionService.deleteOpinion(deletedOpinionId);
    }

    /**
     * 9. 블럭된 의견을 수정할 수 없다.
     */
    @Test(expected = NotFoundException.class)
    @WithUserDetails("user1@googl.co.kr")
    public void T_09_블럭된_의견을_수정할_수_없다() {
        OpinionUpdateDto updateDto = OpinionUpdateDto.of(blockedOpinionId, "블럭된 의견은 수정할 수 없다.");
        opinionService.updateOpinion(updateDto);
    }

    /**
     * 10. 블럭된 의견을 삭제할 수 없다.
     */
    @Test(expected = NotFoundException.class)
    @WithUserDetails("user1@googl.co.kr")
    public void T_10_블럭된_의견을_삭제할_수_없다() {
        opinionService.deleteOpinion(blockedOpinionId);
    }

    /**
     * 11. 사용자는 여러 제안의견 중 하나를 삭제할 수 있다.
     */
    @Test
    @WithUserDetails("user1@googl.co.kr")
    public void T_11_사용자는_여러_제안의견_중_하나를_삭제할_수_있다() {
        final String now = LocalDateTime.now().format(dateTimeFormatter);
        Opinion opinion = opinionService.deleteOpinion(multiOpinionId);

        OpinionDto opinionDto = opinionService.getOpinion(equalId(opinion.getId()), OpinionDto.projection);
        assertThat(opinionDto.getModifiedDate().format(dateTimeFormatter), is(now));
        assertThat(opinionDto.getModifiedBy().getEmail(), is("user1@googl.co.kr"));
        assertThat(opinionDto.getModifiedIp(), is(ip));

        assertThat(opinionDto.getStatus(), is(Opinion.Status.DELETE));

        ProposalDto proposalDto = proposalService.getProposal(ProposalPredicate.equalId(opinion.getIssue().getId()), ProposalDto.projection);
        assertThat(proposalDto.getStats().getOpinionCount(), is(8L));
        assertThat(proposalDto.getStats().getApplicantCount(), is(1L));
    }
}
