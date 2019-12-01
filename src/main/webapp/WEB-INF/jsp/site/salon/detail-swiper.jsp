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
<div class="other-projects">
  <h2>다른 프로젝트 둘러보기</h2>
  <!-- href="<c:url value='/salon.do?id=${each.id}'/>" -->
  <div class="swiper-container">
    <ul class="swiper-wrapper">
      <c:forEach var="each" items="${salons}">
        <li class="salon-project swiper-slide">
          <div
            class="cover"
            style="background-image: url(${each.image});"
          ></div>
          <div class="desc">
            <div class="text-ellipse">
              <span class="category">${salon.category.name}</span>
            </div>
            <h2 class="title">${each.title}</h2>
            <h3 class="team text-ellipse">${each.team}</h3>
          </div>
        </li>
      </c:forEach>
    </ul>
  </div>
  <div class="swiper-button-prev"></div>
  <div class="swiper-button-next"></div>
</div>