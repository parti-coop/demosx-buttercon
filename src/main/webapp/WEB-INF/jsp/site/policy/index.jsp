<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <title>정책살롱 - 버터나이프크루</title>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="home body-salon">
    <%@ include file="../shared/header.jsp" %>

    <div class="container">
      <div class="top-row">
        <h3 class="top-row__title">정책살롱</h3>
        <c:if test="${loginUser.isManager() or loginUser.isAdmin()}">
          <a
            href="<c:url value='/salon-new.do'/>"
            class="btn demo-btn--primary demo-btn-salon"
            >프로젝트 쓰기</a
          >
        </c:if>
      </div>

      <hr class="thick-hr" />

      <h4>버터나이프크루 정책살롱</h4>
      <article>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam
        velit, vulputate eu pharetra nec, mattis ac neque. Duis vulputate
        commodo lectus, ac blandit elit tincidunt id. Sed rhoncus, tortor sed
        eleifend tristique, tortor mauris molestie elit, et lacinia ipsum quam
        nec dui. Quisque nec mauris sit amet elit iaculis pretium sit amet quis
        magna. Aenean velit odio, elementum in tempus ut, vehicula eu diam.
        Pellentesque rhoncus aliquam mattis. Ut vulputate eros sed felis sodales
        nec vulputate justo hendrerit. Vivamus varius pretium ligula, a aliquam
        odio euismod sit amet. Quisque laoreet sem sit amet orci ullamcorper at
        ultricies metus viverra. Pellentesque arcu mauris, malesuada quis ornare
        accumsan, blandit sed diam.
      </article>
      <section>
        <div class="youtube">
          <iframe
            width="560"
            height="315"
            src="https://www.youtube.com/embed/athlPwsuWAw"
            frameborder="0"
            allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen
          ></iframe>
        </div>
        <div class="youtube">
          <iframe
            width="560"
            height="315"
            src="https://www.youtube.com/embed/f6MlZxDP04Y"
            frameborder="0"
            allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen
          ></iframe>
        </div>
      </section>
    </div>

    <section class="projects">
      <div class="container">
        <h4 id="프로젝트">프로젝트</h4>
      </div>
    </section>
    <%@ include file="../shared/footer.jsp" %>
  </body>
</html>
