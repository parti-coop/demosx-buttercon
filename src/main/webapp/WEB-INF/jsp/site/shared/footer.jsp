<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<footer class="demo-footer">
  <div class="container">
    <div class="row">
      <div class="col-sm-3 col-sm-push-9 term-links">
        <%-- <p class="term-link-p"><a class="term-link" href="<c:url value="/notice-list.do"/>"><i
            class="xi-angle-right-min"></i> 공지사항</a></p> --%>
        <p class="term-link-p"><a class="term-link" href="https://event-us.kr/butterknife/event/list" target="_blank">살롱 일정</a></p>
        <p class="term-link-p"><a class="term-link" href="<c:url value="/terms.do"/>">이용약관</a></p>
        <p class="term-link-p"><a class="term-link" href="<c:url value="/privacy.do"/>">개인정보처리방침</a></p>
      </div>
      <div class="col-sm-9 col-sm-pull-3 term-link-logos">
        <a href="http://www.mogef.go.kr/" target="_blank" class="term-link-logo"><img src="${pageContext.request.contextPath}/images/wf-logo.png" alt="여성가족부" style="width:146px"></a>
        <a href="http://gingertproject.co.kr/" target="_blank" class="term-link-logo"><img src="${pageContext.request.contextPath}/images/ginger-logo.png" alt="진저티프로젝트" style="width:71px"></a>
        <a href="http://parti.coop/" target="_blank" class="term-link-logo"><img src="${pageContext.request.contextPath}/images/parti-logo.png" alt="빠띠" style="width:57px"></a>
        <a href="https://www.innogov.go.kr/" target="_blank" class="term-link-logo"><img src="${pageContext.request.contextPath}/images/gv-logo.png" alt="보다나은 정부" style="width:70px"></a>

        <p class="footer-copyright" style="color: #212121;">
          문의
          <a href="mailto:help@butterknifecrew.kr" style="color: #212121;">help@butterknifecrew.kr</a>
        </p>
      </div>
    </div>
  </div>
</footer>
<c:if test="${empty loginUser}">
  <div class="modal fade" id="modal-login" tabindex="-1" role="dialog" aria-labelledby="로그인 모달">
    <div class="modal-dialog modal-dialog--demo" role="document">
      <div class="modal-content">
        <div class="sign-container sign-container--modal">
          <h3 class="demo-detail-title demo-detail-title-sm demo-detail-title-noborder">로그인</h3>
          <div class="terms-wrapper text-center">
            <p class="muted">
              어서 오세요. 로그인 방법을 선택하세요.
            </p>
          </div>
          <div class="login-wrapper">
            <a href="<c:url value="/email-login.do"/>" class="login login-email"><img src="${pageContext.request.contextPath}/images/sign-email.png" alt="이메일로 로그인"> 이메일로 로그인</a>
            <a href="<c:url value="/social-login.do?provider=facebook"/>" class="login login-facebook"><img src="${pageContext.request.contextPath}/images/sign-facebook.png" alt="페이스북으로 로그인"> 페이스북으로 로그인</a>
            <%-- <a href="<c:url value="/social-login.do?provider=naver"/>" class="login-email"><img src="${pageContext.request.contextPath}/images/sign-naver.png" alt="네이버로 로그인"> 네이버로 로그인</a> --%>
            <a href="#" onClick="alert('준비 중입니다.')" class="login login-naver"><img src="${pageContext.request.contextPath}/images/sign-naver.png" alt="네이버로 로그인"> 네이버로 로그인</a>
            <a href="<c:url value="/social-login.do?provider=google"/>" class="login login-google"><img src="${pageContext.request.contextPath}/images/sign-google.png" alt="구글로 로그인"> 구글로 로그인</a>
            <a href="<c:url value="/social-login.do?provider=kakao"/>" class="login login-kakao"><img src="${pageContext.request.contextPath}/images/sign-kakao.png" alt="카카오톡으로 로그인"> 카카오톡으로 로그인</a>
          </div>
          <div class="terms-wrapper text-center">
            <p class="muted">
              <a href="<c:url value="/join.do"/>">
                아직 가입하지 않으셨나요?
                <span class="text-underline">회원가입</span>
              </a>
            </p>
          </div>
          <%-- <form id="form-login-modal">
            <input type="hidden" name="_csrf" value="${_csrf.token}">
            <div class="form-group form-group--demo">
              <label class="demo-form-label" for="modalInputEmail">아이디</label>
              <input type="email" class="form-control demo-input" name="id" id="modalInputEmail" placeholder="이메일"
                     data-parsley-required="true" data-parsley-whitespace="trim">
            </div>
            <div class="form-group form-group--demo">
              <label class="demo-form-label" for="modalInputPassword">비밀번호</label>
              <input type="password" class="form-control demo-input" id="modalInputPassword" name="pw"
                     placeholder="6자리 이상 비밀번호를 설정해 주세요."
                     data-parsley-required="true">
            </div>
            <div class="has-error">
              <p class="help-block help-block-error" id="modal-login-error"></p>
            </div>
            <div class="sing-action">
              <button type="submit" class="btn demo-btn demo-btn--primary btn-sign">로그인</button>
              <button type="button" class="btn d-btn cancel-btn btn-sign next-btn" data-dismiss="modal">취소</button>
            </div>
            <p class="form-help-text form-help-text--blue" style="margin-top: 22px;">
              <a class="blue-link" href="<c:url value="/join.do"/>">아직 회원이 아니신가요? <span style="text-decoration: underline">회원가입</span></a>
            </p>
            <p class="form-help-text form-help-text--blue">
              <a class="blue-link" href="<c:url value="/find-password.do"/>">비밀번호를 잊어버리셨나요? <span style="text-decoration: underline">비밀번호 찾기</span></a>
            </p>
          </form> --%>
          <%-- <div class="login-wrapper">
            <p>*소셜아이디로 로그인</p>
            <a href="<c:url value="/social-login.do?provider=facebook"/>"><img src="${pageContext.request.contextPath}/images/login-facebook.png" alt="페이스북으로 로그인"></a>
            <a href="<c:url value="/social-login.do?provider=naver"/>"><img src="${pageContext.request.contextPath}/images/login-naver.png" alt="네이버로 로그인"></a>
            <a href="<c:url value="/social-login.do?provider=google"/>"><img src="${pageContext.request.contextPath}/images/login-google.png" alt="구글로 로그인"></a>
            <a href="<c:url value="/social-login.do?provider=kakao"/>"><img src="${pageContext.request.contextPath}/images/login-kakao.png" alt="카카오톡으로 로그인"></a>
          </div> --%>
        </div><!-- constainer end  -->
      </div>
    </div>
  </div>
  <script>
    $(function () {
      var $modalLogin = $('#modal-login');
      $(document).on('click', '.show-login-modal', function (event) {
        event.preventDefault();
        $modalLogin.modal('show');
      });
      var $formLoginModal = $('#form-login-modal');
      $formLoginModal.parsley(parsleyConfig);
      $formLoginModal.on('submit', function (event) {
        event.preventDefault();

        $('#modal-login-error').text('');
        $.ajax({
          url: '/loginProcess.do',
          type: 'POST',
          data: {
            '_csrf': $('input[name=_csrf]', this).val(),
            'id': $('input[name=id]', this).val(),
            'pw': $('input[name=pw]', this).val(),
            'ajax': 'on'
          },
          success: function (data) {
            window.location.reload();
          },
          error: function (e) {
            if (e.status === 400)
              $('#modal-login-error').text(e.responseJSON.msg);
          }
        });
      });
    });
  </script>
</c:if>