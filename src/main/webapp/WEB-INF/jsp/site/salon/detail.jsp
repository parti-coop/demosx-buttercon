<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <title>${salon.title} - 버터나이프크루</title>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="body-salon body-salon-detail">
    <%@ include file="../shared/header.jsp" %>

    <div class="container">
      <div class="top-row clearfix">
        <div class="">
          <h3 class="top-row__title">
            <a href="<c:url value='/salon-list.do'/>" class="font-black"
              >문화살롱</a
            >
          </h3>
        </div>
        <section
          class="top-cover"
          style="background-image: url(${salon.files[0].url});"
        >
          <c:if test="${salon.createdBy.id eq loginUser.id}">
            <div class="pull-right margin-20">
              <a
                href="<c:url value='/salon-edit.do?id=${salon.id}'/>"
                class="btn btn-default btn-responsive-sm-md-md"
                >내용수정</a
              >
            </div>
          </c:if>
          <div class="top-cover-margin">
            <!-- <div class="contents-box-tags">
              <span class="contents-box-tags-list">
                <c:forEach var="issueTag" items="${salon.issueTags}">
                  <a
                    href="<c:url value='/salon-list.do?search=%23${issueTag.name}'/>"
                    class="contents-box-tags-link"
                    >${issueTag.name}</a
                  >
                </c:forEach>
              </span>
            </div> -->
            <div class="title-row clearfix">
              <span class="category">${salon.category.name}</span>
              <h2 class="detail-title">${salon.title}</h2>
              <h3 class="detail-teamname">${salon.team}</h3>
              <%@ include file="detail-btns.jsp" %>
            </div>
          </div>
        </section>
      </div>

      <div class="content-container clearfix">
        <div class="demo-side">
          <nav role="navigation" class="table-of-contents">
            <!-- <h2>${salon.title}</h2> -->
            <ul class="toc"></ul>
          </nav>
        </div>
        <div class="demo-content demo-content-right">
          <div class="contents-box">
            <div class="contents-box__contents">${salon.content}</div>
          </div>
          <hr />
          <%@ include file="detail-btns.jsp" %>
        </div>
      </div>
      <hr class="thick-hr" />
      <%@ include file="detail-swiper.jsp" %>
      <!-- demo-row end  -->
    </div>
    <%@ include file="detail-script.jsp" %> <%@ include
    file="../shared/footer.jsp" %>
  </body>
</html>
