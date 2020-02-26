<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>회원가입 - 버터나이프크루</title>
  <%@ include file="./shared/head.jsp" %>
</head>
<body>
<%@ include file="./shared/header.jsp" %>

<div class="sign-container">
  <c:if test="${not joinSuccess}">
    <h3 class="demo-detail-title demo-detail-title-sm demo-detail-title-noborder">회원가입</h3>
    <div class="terms-wrapper text-center">
      <p class="muted">
        어서 오세요. 회원가입 방법을 선택하세요.
      </p>
    </div>
    <div class="login-wrapper">
      <a href="<c:url value="/email-join.do"/>" class="login login-email"><img src="${pageContext.request.contextPath}/images/sign-email.png" alt="이메일로 가입"> 이메일로 가입</a>
      <a href="<c:url value="/social-login.do?provider=facebook"/>" class="login login-facebook"><img src="${pageContext.request.contextPath}/images/sign-facebook.png" alt="페이스북으로 가입"> 페이스북으로 가입</a>
      <a href="<c:url value="/social-login.do?provider=naver"/>" class="login login-naver"><img src="${pageContext.request.contextPath}/images/sign-naver.png" alt="네이버로 가입"> 네이버로 가입</a>
      <a href="<c:url value="/social-login.do?provider=google"/>" class="login login-google"><img src="${pageContext.request.contextPath}/images/sign-google.png" alt="구글로 가입"> 구글로 가입</a>
      <a href="<c:url value="/social-login.do?provider=kakao"/>" class="login login-kakao"><img src="${pageContext.request.contextPath}/images/sign-kakao.png" alt="카카오톡으로 가입"> 카카오톡으로 가입</a>
    </div>
    <div class="terms-wrapper">
      <p class="help">
        가입하기 버튼을 클릭하면 버터나이프크루의
        <a href="<c:url value="/terms.do"/>" target="_blank" class="text-danger text-underline">이용약관</a>과
        <a href="<c:url value="/privacy.do"/>" target="_blank" class="text-danger text-underline">개인정보처리방침</a>에 동의하게 됩니다.
      </p>

      <p class="help">
        2019 청년참여플랫폼 사업의 참여자만 가입이 가능합니다.
      </p>
    </div>
    <hr>
    <div class="terms-wrapper text-center">
      <p class="muted">
        <a href="<c:url value="/login.do"/>">
          이미 가입하셨나요?
          <span class="text-underline">로그인하기</span>
        </a>
      </p>
    </div>
  </c:if>
  <c:if test="${joinSuccess}">
    <h3>회원가입하였습니다.</h3>
    <div class="sing-action">
      <a href="<c:url value="/login.do"/>" class="btn demo-btn demo-btn--primary  btn-sign">로그인하기</a>
    </div>
  </c:if>
</div>

<%@ include file="./shared/footer.jsp" %>

<script>
  $(function () {
    $('#createDto').parsley(parsleyConfig);
  });
</script>
<c:if test="${BLOCK_NEW_USER}">
<script>
  $(function () {
    alert('2019 버터나이프크루 모집이 종료되었습니다.');
    window.history.back();
  });
</script>
</c:if>
</body>
</html>