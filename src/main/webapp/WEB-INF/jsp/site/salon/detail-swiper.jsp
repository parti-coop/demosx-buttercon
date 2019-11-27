<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="https://unpkg.com/swiper/css/swiper.min.css" />
<script src="https://unpkg.com/swiper/js/swiper.min.js"></script>
<script>
  $(function() {
    /** 다른 프로젝트 보기 swiper */
    new Swiper(".swiper-container", {
      loop: true,
      width: 240,
      spaceBetween: 20,
      centeredSlides: true,
      navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev"
      }
    });
  });
</script>
<div class="other-projects swiper-container">
  <h2>다른 프로젝트 둘러보기</h2>
  <!-- href="<c:url value='/salon.do?id=${each.id}'/>" -->
  <ul class="swiper-wrapper">
    <c:forEach var="each" items="${salons}">
      <li class="salon-project swiper-slide">
        <div class="cover" style="background-image: url(${each.image});"></div>
        <div class="desc">
          <div class="contents-box-tags">
            <span class="contents-box-tags-list">
              <c:forEach var="issueTag" items="${each.issueTags}">
                <a
                  href="<c:url value='/salon-list.do?search=%23${issueTag.name}'/>"
                  class="contents-box-tags-link"
                  >${issueTag.name}</a
                >
              </c:forEach>
            </span>
          </div>
          <h2 class="title">${each.title}</h2>
          <h3 class="teamname">${each.team}</h3>
        </div>
      </li>
    </c:forEach>
  </ul>
  <div class="swiper-button-prev"></div>
  <div class="swiper-button-next"></div>
</div>
