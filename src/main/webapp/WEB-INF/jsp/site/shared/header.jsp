<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div class="nav-login-bar">
  <c:if test="${SHOW_BANNER}">
  <div class="header-banner-img-pc">
    <a href="https://2019.butterknifecrew.kr" rel="noopener noreferrer" target="_blank">
      <img 
        src="/images/onlinereport-bn-pc.jpg" 
        srcset="/images/onlinereport-bn-pc@2x.jpg 2x,
                /images/onlinereport-bn-pc@3x.jpg 3x"
        alt="banner" />
    </a>
  </div>
  </c:if>
  <div class="container">
    <ul class="nav-login-ul list-inline text-right">
      <c:if test="${empty loginUser}">
        <li class="nav-login-li"><a href="<c:url value='/login.do'/>" class="nav-login-li__link show-login-modal">로그인</a></li>
        <li class="nav-login-li"><span class="li-middle-line">&nbsp;</span></li>
        <li class="nav-login-li"><a href="<c:url value='/join.do'/>" class="nav-login-li__link">회원가입</a></li>
      </c:if>
      <c:if test="${not empty loginUser}">
        <c:if test="${loginUser.isAdmin() or loginUser.isManager()}">
          <li class="nav-login-li"><a href="<c:url value='/admin/index.do'/>" class="nav-login-li__link">관리자페이지</a></li>
          <li class="nav-login-li"><span class="li-middle-line">&nbsp;</span></li>
        </c:if>
        <li class="nav-login-li"><a href="<c:url value='/mypage/info.do'/>" class="nav-login-li__link">
          <div class="profile-circle profile-circle--nav" style="background-image: url('${loginUser.viewPhoto()}')">
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
  <c:if test="${SHOW_BANNER}">
  <div class="header-banner-img-mobile">
    <a href="https://2019.butterknifecrew.kr" rel="noopener noreferrer" target="_blank">
      <img 
        src="/images/onlinereport-bn-mobile.jpg"
        srcset="/images/onlinereport-bn-mobile@2x.jpg 2x,
                /images/onlinereport-bn-mobile@3x.jpg 3x"
        alt="banner" />
    </a>
  </div>
  </c:if>
  <div class="container">
    <div class="navbar-header navbar-header--demo">
      <button type="button" class="navbar-toggle navbar-toggle--demo collapsed" data-toggle="collapse"
              data-target="#demo-navbar-collapse" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <i class="xi-bars xi-2x demo-toggle demo-toggle--open"></i>
        <i class="xi-close xi-2x demo-toggle demo-toggle--close"></i>
      </button>
      <a class="navbar-brand navbar-brand--demo" href="<c:url value='/index.do'/>">
        <img src="${pageContext.request.contextPath}/images/butttercon-kr-logo.png">
        <!-- <span class="beta">beta</span> -->
      </a>
    </div>

    <!-- 모바일 펼쳐진 메뉴 -->
    <div class="demo-collapse collapse navbar-collapse" id="demo-navbar-collapse">
      <a class="visible-xs navbar-brand navbar-brand--demo navbar-brand--demo--collapse" href="<c:url value='/index.do'/>">
        <img src="${pageContext.request.contextPath}/images/butttercon-kr-logo.png">
      </a>
      <ul class="nav navbar-nav navbar-right demo-nav">
        <li class="demo-nav-li"><a href="<c:url value='/intro.do'/>">버터나이프크루 1기</a></li>
        <li class="li-middle"><span class="li-middle-line">&nbsp;</span></li>
        <li class="demo-nav-li <c:if test="${controllerName eq 'Policy'}">active</c:if>"><a href="<c:url value='/policy.do'/>">1기 정책살롱</a></li>

        <c:if test="${not empty loginUser}">
        <li class="demo-nav-li <c:if test="${controllerName eq 'Proposal'}">active</c:if>"><a href="<c:url value='/proposal-list.do'/>">아이디어</a></li>
        <li class="demo-nav-li <c:if test="${controllerName eq 'Butter'}">active</c:if>"><a href="<c:url value='/butter-list.do'/>">버터보드</a></li>
        </c:if>
        
        <li class="demo-nav-li <c:if test="${controllerName eq 'Salon'}">active</c:if>"><a href="<c:url value='/content-list.do'/>" >1기 문화살롱</a></li>
      </ul>

      <div class="nav-login-m">
        <!-- mobile login START -->
        <ul class="nav-login-m-ul clearfix">
          <c:if test="${empty loginUser}">
            <li class="nav-login-m-li">
              <a href="<c:url value='/login.do'/>" class="nav-login-m-li__link">로그인</a>
            </li>
            <li class="nav-login-m-li">
              <a href="<c:url value='/join.do'/>" class="nav-login-m-li__link nav-login-m-li__link--last">회원가입</a>
            </li>
          </c:if>
          <c:if test="${not empty loginUser}">
            <li class="nav-login-m-li">
              <a href="<c:url value='/mypage/info.do'/>" class="nav-login-m-li__link">${loginUser.name}</a>
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