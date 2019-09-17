<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>비밀번호찾기 - Democracy</title>
  <%@ include file="./shared/head.jsp" %>
</head>
<body>
<%@ include file="./shared/header.jsp" %>

<div class="sign-container">
  <h3 class="demo-detail-title">비밀번호찾기</h3>
  <form action="<c:url value="/find-password.do"/>" method="post" id="je-find-password">
    <input type="hidden" name="_csrf" value="${_csrf.token}">
    <div class="form-group form-group--demo">
      <label class="demo-form-label" for="inputEmail">이메일로 비밀번호 재설정 링크 전달</label>
      <input type="email" class="form-control demo-input" name="email" value="${email}" id="inputEmail" placeholder="이메일을 입력해 주세요."
             data-parsley-required="true" data-parsley-type="email"
             data-parsley-error-message="이메일을 적어주세요.">

      <c:if test="${reset eq true}">
        <div class="has-error">
          <h4 class="control-label">이메일로 패스워드 재설정 링크를 전달하였습니다.<br>확인해 주세요.</h4>
        </div>
      </c:if>
      <c:if test="${not_found eq true}">
        <div class="has-error">
          <h4 class="control-label">입력한 이메일로 가입한 회원이 없습니다.<br>다시 확인해 주세요.</h4>
        </div>
      </c:if>
    </div>
    <button type="submit" class="btn demo-btn demo-btn--primary btn-sign">비밀번호 재설정</button>
    <p class="form-help-text form-help-text--blue" style="margin-top: 22px;">
      <a class="blue-link" href="<c:url value="/join.do"/>">아직 회원이 아니신가요? <span style="text-decoration: underline">회원가입</span></a>
    </p>
    <p class="form-help-text form-help-text--blue">
      <a class="blue-link" href="<c:url value="/login.do"/>">비밀번호가 기억나셨나요? <span style="text-decoration: underline">로그인</span></a>
    </p>
  </form>
</div>

<%@ include file="./shared/footer.jsp" %>

<script>
  $(function () {
    $('#je-find-password').parsley(parsleyConfig);
  });
</script>
</body>
</html>