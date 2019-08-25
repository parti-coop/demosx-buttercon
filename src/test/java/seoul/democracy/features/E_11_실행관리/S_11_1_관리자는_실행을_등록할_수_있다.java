package seoul.democracy.features.E_11_실행관리;

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
import seoul.democracy.action.domain.Action;
import seoul.democracy.action.dto.ActionCreateDto;
import seoul.democracy.action.dto.ActionDto;
import seoul.democracy.action.service.ActionService;
import seoul.democracy.common.exception.BadRequestException;
import seoul.democracy.issue.domain.Issue;
import seoul.democracy.issue.dto.IssueFileDto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;

import static org.hamcrest.Matchers.*;
import static org.junit.Assert.assertThat;
import static seoul.democracy.action.dto.ActionDto.projection;
import static seoul.democracy.action.predicate.ActionPredicate.equalId;

/**
 * epic : 11. 실행관리
 * story: 11.1 관리자는 실행을 등록할 수 있다.
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
public class S_11_1_관리자는_실행을_등록할_수_있다 {

    private final static DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH-mm");
    private final static String ip = "127.0.0.2";
    private MockHttpServletRequest request;

    @Autowired
    private ActionService actionService;

    private ActionCreateDto createDto;

    @Before
    public void setUp() throws Exception {
        request = new MockHttpServletRequest();
        request.setRemoteAddr(ip);
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));

        createDto = ActionCreateDto.of("update-thumbnail.jpg", "경제",
            "실행 등록합니다.", "실행 내용입니다.", Issue.Status.CLOSED,
            Arrays.asList(IssueFileDto.of("파일1", "file1"), IssueFileDto.of("파일2", "file2")),
            Arrays.asList(1L, 101L), null);
    }

    /**
     * 1. 관리자는 실행을 등록할 수 있다.
     */
    @Test
    @WithUserDetails("admin1@googl.co.kr")
    public void T_1_관리자는_실행을_등록할_수_있다() {
        final String now = LocalDateTime.now().format(dateTimeFormatter);

        Action action = actionService.create(createDto);
        assertThat(action.getId(), is(notNullValue()));

        ActionDto actionDto = actionService.getAction(equalId(action.getId()), projection, true, true);
        assertThat(actionDto.getCreatedDate().format(dateTimeFormatter), is(now));
        assertThat(actionDto.getModifiedDate().format(dateTimeFormatter), is(now));
        assertThat(actionDto.getCreatedBy().getEmail(), is("admin1@googl.co.kr"));
        assertThat(actionDto.getModifiedBy().getEmail(), is("admin1@googl.co.kr"));
        assertThat(actionDto.getCreatedIp(), is(ip));
        assertThat(actionDto.getModifiedIp(), is(ip));

        assertThat(actionDto.getCategory().getName(), is(createDto.getCategory()));

        assertThat(actionDto.getStats().getViewCount(), is(0L));

        assertThat(actionDto.getThumbnail(), is(createDto.getThumbnail()));

        assertThat(actionDto.getTitle(), is(createDto.getTitle()));
        assertThat(actionDto.getContent(), is(createDto.getContent()));

        assertThat(actionDto.getStatus(), is(createDto.getStatus()));

        assertThat(actionDto.getFiles(), contains(createDto.getFiles().toArray(new IssueFileDto[0])));
        assertThat(actionDto.getRelations(), contains(createDto.getRelations().toArray(new Long[0])));
    }

    /**
     * 2. 매니저는 실행을 등록할 수 없다.
     */
    @Test(expected = AccessDeniedException.class)
    @WithUserDetails("manager1@googl.co.kr")
    public void T_2_매니저는_실행을_등록할_수_없다() {
        actionService.create(createDto);
    }

    /**
     * 3. 사용자는 실행을 등록할 수 없다.
     */
    @Test(expected = AccessDeniedException.class)
    @WithUserDetails("user1@googl.co.kr")
    public void T_3_사용자는_실행을_등록할_수_없다() {
        actionService.create(createDto);
    }

    /**
     * 4. 존재하지 않는 항목을 연관으로 등록할 수 없다.
     */
    @Test(expected = BadRequestException.class)
    @WithUserDetails("admin1@googl.co.kr")
    public void T_4_존재하지_않는_항목을_연관으로_등록할_수_없다() {
        Long notExistsRelation = 999L;
        createDto.setRelations(Arrays.asList(1L, 101L, notExistsRelation));
        actionService.create(createDto);
    }
}
