<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>버터나이프크루</title>
  <%@ include file="./shared/head.jsp" %>

  <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.4.2/css/swiper.min.css"/>
  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.4.2/js/swiper.min.js"></script>
</head>
<body class="home header-no-margin">
<%@ include file="./shared/header.jsp" %>

<section class="section-main-key-visual">
  <div class="container">
    <div class="key-title">
      나의 삶은 달라지고 있고,
      <br>
      우리가 변화의 흐름을 만든다
    </div>
    <div class="key-subtitle">
      버터나이프크루는
      <br>
      우리의 달라진 삶에 필요한 정책을 제안하고 (정책살롱)
      <br>
      우리의 달라진 삶을 반영하는 문화혁신사업(문화살롱)을
      <br class="visible-xs"/>
      진행하는 청년참여플랫폼입니다.
    </div>
    <a href="<c:url value="/intro.do"/>" class="btn demo-btn demo-btn--primary key-btn">자세히보기</a>
  </div>
</section>
<section class="section-banner">
  <div class="container">
    <div class="key-banner">
      <div class="key-banner-text">
        <span class="text-nowrap">
          예정된 정책 살롱 일정을 확인하고
        </span>
        <br class="visible-xs"/>
        <span class="text-nowrap">
          오프라인 모임에 참여해보세요!
        </span>
      </div>
      <div class="key-banner-btn-container">
        <a href="#" class="key-banner-btn btn demo-btn demo-btn--primary">
          <span class="hidden-xs">정책 살롱</span> 참여하기
        </a>
      </div>
  </div>
</section>
<section class="section-proposals">
  <div class="container">
    <div class="main-card-wrapper">
      <div class="main-card-wrapper-title">최근 아이디어</div>
      <div class="main-card-wrapper-subtitle">변화의 흐름을 만든다</div>
      <div class="row">
        <c:forEach var="item" items="${latest.content}">
          <c:set var="proposal" value="${item}" scope="request"/>
          <div class="col-sm-6 demo-card-wrapper">
            <jsp:include page="./proposal/card.jsp"/>
          </div>
        </c:forEach>
      </div>
    </div>

    <div class="show-more-container text-center">
      <a class="btn white-default-btn" href="<c:url value="/proposal-list.do"/>">더보기<i
          class="xi-angle-down-min"></i></a>
    </div>
  </div>
</section>

<script>
  $(function () {
    new Swiper('.swiper-container', {
      // Optional parameters
      //direction: 'vertical',
      loop: true,
      autoplay: {
        delay: 4000
      },
      pagination: {
        el: '.swiper-pagination',
        clickable: true
      },
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev'
      }
    });
  });
</script>

<%@ include file="./shared/footer.jsp" %>
</body>
</html>
