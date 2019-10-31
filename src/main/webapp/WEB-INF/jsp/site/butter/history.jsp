<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="body-butter body-butter-new">
    <%@ include file="../shared/header.jsp" %>

    <div class="container">
      <div class="butter-title">
        ${after.issue.title}
      </div>
      <div class="butter-content">
        발행 내용
      </div>
      <div id="js-mergely" data-read-only="true"></div>
      <div class="butter-excerpt-label">
        버터 요약
      </div>
      <div class="butter-excerpt form-group--demo">
        <input type="text" value="${before.excerpt}" disabled />
        <input type="text" name="excerpt" value="${after.excerpt}" disabled />
      </div>
      <div class="form-action form-group-butter">
        <div class="butter-btn-group">
          <div>
            <a
              class="btn btn-default btn-lg"
              href="<c:url value='/butter.do?id=${after.issue.id}'/>"
              role="button"
              >돌아가기</a
            >
          </div>
        </div>
      </div>
    </div>
    <%@ include file="../shared/footer.jsp" %> <%@ include
    file="history-script.jsp" %>
  </body>
</html>
