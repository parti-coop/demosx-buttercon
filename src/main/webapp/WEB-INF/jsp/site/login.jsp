<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>로그인 - 버터나이프크루</title>
  <%@ include file="./shared/head.jsp" %>
</head>
<body>
<%@ include file="./shared/header.jsp" %>

<div class="sign-container">
  <h3 class="demo-detail-title demo-detail-title-sm demo-detail-title-noborder">로그인</h3>
  <div class="terms-wrapper text-center">
    <p class="muted">
      어서 오세요. 로그인 방법을 선택하세요.
    </p>
  </div>
  <div class="login-wrapper">
    <a href="<c:url value="/email-login.do"/>" class="login login-email"><img src="${pageContext.request.contextPath}/images/sign-email.png" alt="이메일로 로그인"> 이메일로 로그인</a>
    <a href="<c:url value="/social-login.do?provider=facebook"/>" class="login login-facebook"><img src="${pageContext.request.contextPath}/images/sign-facebook.png" alt="페이스북으로 로그인"> 페이스북으로 로그인</a>
    <a href="<c:url value="/social-login.do?provider=naver"/>" class="login login-naver"><img src="${pageContext.request.contextPath}/images/sign-naver.png" alt="네이버로 로그인"> 네이버로 로그인</a>
    <!-- <a href="#" onClick="alert('준비 중입니다.')" class="login login-naver"><img src="${pageContext.request.contextPath}/images/sign-naver.png" alt="네이버로 로그인"> 네이버로 로그인</a> -->
    <a href="<c:url value="/social-login.do?provider=google"/>" class="login login-google"><img src="${pageContext.request.contextPath}/images/sign-google.png" alt="구글로 로그인"> 구글로 로그인</a>
    <a href="<c:url value="/social-login.do?provider=kakao"/>" class="login login-kakao"><img src="${pageContext.request.contextPath}/images/sign-kakao.png" alt="카카오톡으로 로그인"> 카카오톡으로 로그인</a>
  </div>
  <div class="terms-wrapper">
    <p class="help">
      로그인하기 버튼을 클릭하면 버터나이프크루의
      <a href="<c:url value="/terms.do"/>" target="_blank" class="text-danger text-underline">이용약관</a>과
      <a href="<c:url value="/terms.do"/>" target="_blank" class="text-danger text-underline">개인정보처리방침</a>에 동의하게 됩니다.
    </p>

    <p class="help">
      2019 청년참여플랫폼 사업의 참여자만 로그인이 가능합니다.
    </p>
  </div>
  <hr>
  <div class="terms-wrapper text-center">
    <p class="muted">
      <a href="<c:url value="/join.do"/>">
        아직 가입하지 않으셨나요?
        <span class="text-underline">회원가입</span>
      </a>
    </p>
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