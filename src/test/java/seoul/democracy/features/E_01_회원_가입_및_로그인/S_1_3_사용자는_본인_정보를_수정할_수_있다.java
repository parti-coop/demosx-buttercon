package seoul.democracy.features.E_01_회원_가입_및_로그인;

import org.junit.Before;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.test.context.support.WithUserDetails;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;
import seoul.democracy.common.exception.BadRequestException;
import seoul.democracy.user.domain.User;
import seoul.democracy.user.dto.UserDto;
import seoul.democracy.user.dto.UserUpdateDto;
import seoul.democracy.user.predicate.UserPredicate;
import seoul.democracy.user.service.UserService;

import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;


/**
 * epic : 1. 회원 가입 및 로그인
 * story : 1.3 사용자는 본인 정보를 수정할 수 있다.
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
public class S_1_3_사용자는_본인_정보를_수정할_수_있다 {

    @Autowired
    private UserService userService;

    @Before
    public void setUp() throws Exception {
    }

    /**
     * 1. 이름, 프로필 사진을 수정할 수 있다.
     */
    @Test
    @WithUserDetails("user1@googl.co.kr")
    public void T_1_이름_프로필_사진을_수정할_수_있다() {
        UserUpdateDto updateDto = UserUpdateDto.of("유저999", "photo999.jpg", "12345");
        User user = userService.update(updateDto);
        assertThat(user.getId(), is(21L));

        UserDto userDto = userService.getUser(UserPredicate.equalEmail("user1@googl.co.kr"), UserDto.projection);
        assertThat(userDto.getName(), is(updateDto.getName()));
        assertThat(userDto.getPhoto(), is(updateDto.getPhoto()));
    }

    /**
     * 2. 비밀번호 다를 경우 수정할 수 없다.
     */
    @Test(expected = BadRequestException.class)
    @WithUserDetails("user1@googl.co.kr")
    public void T_2_비밀번호_다를_경우_수정할_수_없다() {
        UserUpdateDto updateDto = UserUpdateDto.of("유저999", "photo999.jpg", "wrongpassword");
        userService.update(updateDto);
    }

}