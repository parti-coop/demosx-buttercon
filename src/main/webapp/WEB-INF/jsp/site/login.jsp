<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>로그인 - Democracy</title>
  <%@ include file="./shared/head.jsp" %>
</head>
<body>
<%@ include file="./shared/header.jsp" %>

<div class="sign-container">
  <h3 class="demo-detail-title">로그인</h3>
  <form method="post" action="<c:url value="/loginProcess.do"/>" id="form-login">
    <input type="hidden" name="_csrf" value="${_csrf.token}">
    <div class="form-group form-group--demo">
      <label class="demo-form-label" for="inputEmail">아이디</label>
      <input type="email" class="form-control demo-input" name="id" id="inputEmail" placeholder="이메일"
             data-parsley-required="true" data-parsley-whitespace="trim">
    </div>

    <div class="form-group form-group--demo">
      <label class="demo-form-label" for="inputPassword">비밀번호</label>
      <input type="password" class="form-control demo-input" name="pw" id="inputPassword"
             placeholder="6자리 이상 비밀번호를 설정해 주세요."
             data-parsley-required="true">
    </div>
    <c:if test="${not empty loginError}">
      <div class="has-error">
        <p class="help-block help-block-error">아이디 및 비밀번호를 확인해 주세요.</p>
      </div>
    </c:if>
    <div class="sing-action">
      <button type="submit" class="btn demo-btn demo-btn--primary btn-sign">로그인</button>
    </div>
    <p class="form-help-text form-help-text--blue" style="margin-top: 22px;">
      <a class="blue-link" href="<c:url value="/join.do"/>">아직 회원이 아니신가요? <span style="text-decoration: underline">회원가입</span></a>
    </p>
    <p class="form-help-text form-help-text--blue">
      <a class="blue-link" href="<c:url value="/find-password.do"/>">비밀번호를 잊어버리셨나요? <span style="text-decoration: underline">비밀번호 찾기</span></a>
    </p>

  </form>
  <div class="social-login-wrapper">
    <p>*소셜아이디로 로그인</p>
    <a href="<c:url value="/social-login.do?provider=facebook"/>"><img src="<c:url value="/images/login-facebook.png"/>" alt="페이스북으로 로그인"></a>
    <a href="<c:url value="/social-login.do?provider=naver"/>"><img src="<c:url value="/images/login-naver.png"/>" alt="네이버로 로그인"></a>
    <a href="<c:url value="/social-login.do?provider=google"/>"><img src="<c:url value="/images/login-google.png"/>" alt="구글로 로그인"></a>
    <a href="<c:url value="/social-login.do?provider=kakao"/>"><img src="<c:url value="/images/login-kakao.png"/>" alt="카카오톡으로 로그인"></a>
  </div>
</div>

<%@ include file="./shared/footer.jsp" %>

<script>
  $(function () {
    $('#form-login').parsley(parsleyConfig);
  });
</script>
</body>
</html>