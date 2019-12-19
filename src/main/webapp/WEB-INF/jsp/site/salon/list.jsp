<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <title>문화살롱 - 버터나이프크루</title>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="home body-salon">
    <%@ include file="../shared/header.jsp" %>

    <div class="container">
      <div class="top-row">
        <h3 class="top-row__title">문화살롱</h3>
        <c:if test="${loginUser.isManager() or loginUser.isAdmin()}">
          <a
            href="<c:url value='/content-new.do'/>"
            class="btn demo-btn--primary demo-btn-salon"
            >프로젝트 쓰기</a
          >
        </c:if>
      </div>

      <hr class="thick-hr" />

      <h4>버터나이프크루 문화살롱</h4>
      <article>
        버터나이프크루의 문화살롱은 청년의 달라진 삶을 다양한 콘텐츠로 나타내는 문화혁신사업입니다.
        <br />
        청년의 다양한 삶을 성평등의 관점으로 나타낼 수 있는 아이디어를 도전 의지와 열정으로 실현시키고자 하는 분들을 지원하였고, 
        <br />
        문화살롱에 참여하는 서로 서로가 연결되어 네트워크가 되기를 기대했습니다. 
        <br />
        <br />
        2019 버터나이프크루 문화살롱은 주거・가족・일・지역・건강・대중문화・성평등 교육 등을 주제로 수도권・순천・김해・부산・제주 5개 지역에서 
        <br />
        청년의 달라진 삶을 영상, 웹툰, 책자, 연구 보고서 등 다양한 콘텐츠로 표현하였습니다.
      </article>
      <section>
        <div class="youtube">
          <iframe
            width="560"
            height="315"
            src="https://www.youtube.com/embed/i-5hX0LDI9w"
            frameborder="0"
            allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen
          ></iframe>
        </div>
        <div class="youtube">
          <iframe
            width="560"
            height="315"
            src="https://www.youtube.com/embed/JnrTcIsTlpU"
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
        <div class="categories">
          <a href="?category=#프로젝트" class="category <c:if test="${empty category or category eq ''}">selected</c:if> ">전체</a>
          <c:forEach var="cate" items="${categories}">
            <a 
              href="?category=${cate.name}#프로젝트"
              class="category <c:if test='${category eq cate.name}'>selected</c:if> ">${cate.name}</a>
          </c:forEach>
        </div>
        <div class="card-wrapper">
          <div class="row">
            <c:forEach var="item" items="${page.content}">
              <c:set var="salon" value="${item}" scope="request" />
              <div class="col-sm-4 demo-card-wrapper">
                <jsp:include page="card.jsp" />
              </div>
            </c:forEach>
          </div>
        </div>
        <div class="card-wrapper-mobile">
          <div class="row">
            <c:forEach var="item" items="${page.content}">
              <c:set var="salon" value="${item}" scope="request" />
              <div class="col-sm-4 demo-card-wrapper">
                <jsp:include page="card-mobile.jsp" />
              </div>
            </c:forEach>
          </div>
        </div>
      </div>
    </section>
    <%@ include file="../shared/footer.jsp" %>
  </body>
</html>
