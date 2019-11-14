package seoul.democracy.features.E_14_버터문서;

import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.notNullValue;
import static org.junit.Assert.assertThat;
import static seoul.democracy.butter.dto.ButterDto.projection;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

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

import seoul.democracy.issue.domain.Issue;
import seoul.democracy.opinion.domain.OpinionType;
import seoul.democracy.butter.domain.Butter;
import seoul.democracy.butter.dto.ButterCreateDto;
import seoul.democracy.butter.dto.ButterDto;
import seoul.democracy.butter.predicate.ButterPredicate;
import seoul.democracy.butter.service.ButterService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/main/resources/egovframework/spring/context-*.xml",
        "file:src/test/resources/egovframework/spring-test/context-*.xml",
        "file:src/main/webapp/WEB-INF/config/egovframework/springmvc/egov-com-*.xml" })
@Sql({ "file:src/test/resources/sql/test-data.sql" })
@Transactional
@Rollback
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@ActiveProfiles("test")
public class S_14_1_사용자는_버터문서_등록 {

    private final static DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH-mm");
    private final static String ip = "127.0.0.1";

    @Autowired
    private ButterService butterService;

    @Before
    public void setUp() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setRemoteAddr(ip);
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));
    }

    /**
     * 1. 사용자는 제목,내용으로 제안을 등록할 수 있다.
     */
    @Test
    @WithUserDetails("user1@googl.co.kr")
    public void T_1_새로등록() {
        final String now = LocalDateTime.now().format(dateTimeFormatter);
        ButterCreateDto createDto = ButterCreateDto.of("제안합니다.", "제안내용입니다.", "환경", now, null, null, null, null, null);
        Butter butter = butterService.create(createDto);
        assertThat(butter.getId(), is(notNullValue()));

        ButterDto butterDto = butterService.getButter(ButterPredicate.equalId(butter.getId()), projection);
        assertThat(butterDto.getCreatedDate().format(dateTimeFormatter), is(now));
        assertThat(butterDto.getModifiedDate().format(dateTimeFormatter), is(now));
        assertThat(butterDto.getCreatedBy().getEmail(), is("user1@googl.co.kr"));
        assertThat(butterDto.getModifiedBy().getEmail(), is("user1@googl.co.kr"));
        assertThat(butterDto.getCreatedIp(), is(ip));
        assertThat(butterDto.getModifiedIp(), is(ip));

        assertThat(butterDto.getOpinionType(), is(OpinionType.PROPOSAL));

        assertThat(butterDto.getStats().getViewCount(), is(0L));
        assertThat(butterDto.getStats().getLikeCount(), is(0L));
        assertThat(butterDto.getStats().getOpinionCount(), is(0L));
        assertThat(butterDto.getStats().getYesCount(), is(1L));
        assertThat(butterDto.getStats().getNoCount(), is(0L));
        assertThat(butterDto.getStats().getEtcCount(), is(0L));

        assertThat(butterDto.getStatus(), is(Issue.Status.OPEN));

        assertThat(butterDto.getTitle(), is(createDto.getTitle()));
        assertThat(butterDto.getContent(), is(createDto.getContent()));

    }

}
