<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <title>
      <c:if test="${environmentName ne 'production'}">DEV -
      </c:if>버터나이프크루
    </title>
    <script>
      const READONLY = true;
    </script>
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
      <div class="form-action form-group-butter text-right">
        <div class="inline-block">
          <a
            class="btn btn-default btn-lg butter-cancel"
            href="<c:url value='/butter.do?id=${after.issue.id}'/>"
            role="button"
            >돌아가기</a
          >
        </div>
      </div>
    </div>
    <%@ include file="../shared/footer.jsp" %> <%@ include
    file="history-script.jsp" %>
  </body>
</html>
