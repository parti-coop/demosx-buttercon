<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <title>버터나이프크루</title>
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
      <div class="mergely">
        <div class="mergely-resizer">
          <div id="mergely"></div>
        </div>
      </div>
      <div class="butter-excerpt-label">
        버터 요약
      </div>
      <div class="mergely-excerpt">
        <input type="text" value="${before.excerpt}" disabled />
        <input type="text" name="excerpt" value="${after.excerpt}" disabled />
      </div>
    </div>
    <%@ include file="../shared/footer.jsp" %> <%@ include
    file="history-script.jsp" %>
  </body>
</html>
