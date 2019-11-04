<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div class="nav-login-bar">
  <div class="container">
    <ul class="nav-login-ul list-inline text-right">
      <c:if test="${empty loginUser}">
        <li class="nav-login-li"><a href="<c:url value="/login.do"/>" class="nav-login-li__link show-login-modal">로그인</a></li>
        <li class="nav-login-li"><span class="li-middle-line">&nbsp;</span></li>
        <li class="nav-login-li"><a href="<c:url value="/join.do"/>" class="nav-login-li__link">회원가입</a></li>
      </c:if>
      <c:if test="${not empty loginUser}">
        <c:if test="${loginUser.isAdmin() or loginUser.isManager()}">
          <li class="nav-login-li"><a href="<c:url value="/admin/index.do"/>" class="nav-login-li__link">관리자페이지</a></li>
          <li class="nav-login-li"><span class="li-middle-line">&nbsp;</span></li>
        </c:if>
        <li class="nav-login-li"><a href="<c:url value="/mypage/info.do"/>" class="nav-login-li__link">
          <div class="profile-circle profile-circle--nav" style="background-image: url(${loginUser.viewPhoto()})">
            <p class="alt-text">${loginUser.name}프로필</p>
          </div>
          ${ loginUser.name}
        </a></li>
        <li class="nav-login-li"><span class="li-middle-line">&nbsp;</span></li>
        <li class="nav-login-li"><a href="#" class="nav-login-li__link logout-link">로그아웃</a></li>
        <form:form action="/logout.do" method="post" class="hidden" id="form-logout">
        </form:form>
        <script>
          $(function () {
            $('.logout-link').click(function (event) {
              event.preventDefault();
              $('#form-logout').submit();
            });
          });
        </script>
      </c:if>
    </ul>
  </div>
</div>
<nav class="navbar navbar-default navbar-default--demo">
  <div class="container">
    <div class="navbar-header navbar-header--demo">
      <button type="button" class="navbar-toggle navbar-toggle--demo collapsed" data-toggle="collapse"
              data-target="#demo-navbar-collapse" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <i class="xi-bars xi-2x demo-toggle demo-toggle--open"></i>
        <i class="xi-close xi-2x demo-toggle demo-toggle--close"></i>
      </button>
      <a class="navbar-brand navbar-brand--demo" href="<c:url value="/index.do"/>">
        <img src="${pageContext.request.contextPath}/images/butttercon-kr-logo.png">
        <span class="beta">beta</span>
      </a>
    </div>

    <!-- 모바일 펼쳐진 메뉴 -->
    <div class="demo-collapse collapse navbar-collapse" id="demo-navbar-collapse">
      <a class="visible-xs navbar-brand navbar-brand--demo navbar-brand--demo--collapse" href="#">
        <img src="${pageContext.request.contextPath}/images/butttercon-kr-logo.png">
      </a>
      <ul class="nav navbar-nav navbar-right demo-nav">
        <li class="demo-nav-li">
          <a href="<c:url value="/intro.do"/>">버터나이프크루</a>
        </li>
        <li class="li-middle"><span class="li-middle-line">&nbsp;</span></li>
        <li class="demo-nav-li <c:if test="${controllerName eq 'Proposal'}">active</c:if>">
          <a href="<c:url value="/proposal-list.do"/>">
            아이디어
          </a>
        </li>
        <%-- <li class="li-middle"><span class="li-middle-line">|</span></li>
        <li class="demo-nav-li"><a href="<c:url value="/org-debate-list.do"/>">기관제안
        </a></li> --%>
        <!-- <li class="li-middle"><span class="li-middle-line">|</span></li> -->
        <!-- <li class="demo-nav-li"><a href="#" onclick="alert('서비스를 시작하지 않았습니다')">버터보드 -->
        <li class="demo-nav-li"><a href="<c:url value="/butter-list.do"/>">버터보드</a></li>
        <li class="dropdown demo-nav-li">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            가이드
            <i class="xi-angle-down-thin"></i>
          </a>
          <ul class="dropdown-menu dopdown-menu-auto">
            <li class="dropdown-item">
              <a href="<c:url value='/butter.do?id=141'/>" class="dropdown-link">버터보드 공동작업 가이드</a>
            </li>
            <li class="dropdown-item">
              <a href="<c:url value='/butter.do?id=146'/>" class="dropdown-link">정책 제안 점검 체크리스트</a>
            </li>
            <li class="dropdown-item">
              <a href="<c:url value='/butter.do?id=144'/>" class="dropdown-link">마크다운 문서 작성법</a>
            </li>
            <li class="dropdown-item">
              <a href="<c:url value='/butter.do?id=150'/>" class="dropdown-link">정책 제안을 위한 팀 대화 가이드</a>
            </li>
          </ul>
        </li>
      </ul>

      <div class="nav-login-m">
        <!-- mobile login START -->
        <ul class="nav-login-m-ul clearfix">
          <c:if test="${empty loginUser}">
            <li class="nav-login-m-li">
              <a href="<c:url value="/login.do"/>" class="nav-login-m-li__link">로그인</a>
            </li>
            <li class="nav-login-m-li">
              <a href="<c:url value="/join.do"/>" class="nav-login-m-li__link nav-login-m-li__link--last">회원가입</a>
            </li>
          </c:if>
          <c:if test="${not empty loginUser}">
            <li class="nav-login-m-li">
              <a href="<c:url value="/mypage/info.do"/>" class="nav-login-m-li__link">${loginUser.name}</a>
            </li>
            <li class="nav-login-m-li">
              <a href="#" class="nav-login-m-li__link nav-login-m-li__link--last logout-link">로그아웃</a>
            </li>
          </c:if>
        </ul>
      </div><!-- mobile login ENDs -->

    </div>
  </div>
</nav>