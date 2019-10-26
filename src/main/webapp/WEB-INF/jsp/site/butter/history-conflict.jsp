<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
  <head>
    <title>버터나이프크루</title>
    <script>
      const READONLY = false;
    </script>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="body-butter body-butter-new">
    <%@ include file="../shared/header.jsp" %>

    <div class="container">
      <div class="butter-conflict">
        <p>
          버터보드 추가 중 이전 발행 내용과 충돌이 났습니다.
        </p>
        <p>
          오류가 아닙니다. 안심하세요. :)
        </p>
      </div>
      <div class="butter-title">
        ${after.issue.title}
      </div>
      <div class="butter-content">
        <div class="pull-left">이전 발행 내용입니다.</div>
        <div class="pull-right">
          방금 발행 내용입니다. 여기서 계속 수정하세요.
        </div>
      </div>
      <div class="mergely">
        <div class="mergely-resizer">
          <div id="mergely"></div>
        </div>
      </div>
      <div class="butter-excerpt-label">
        버터 요약
      </div>
      <form class="demo-form js-form-dirrty" id="form-edit-butter">
        <div class="mergely-excerpt form-group--demo">
          <input type="text" value="${before.excerpt}" disabled />
          <input type="text" name="excerpt" value="${after.excerpt}" />
          <input type="hidden" name="id" value="${after.issue.id}" />
          <input type="hidden" name="isConflict" value="true" />
          <input type="hidden" name="recentHistoryId" value="${before.id}" />
        </div>
        <div class="form-action form-group-butter text-right">
          <div class="inline-block">
            <a
              class="btn btn-default btn-lg butter-cancel"
              href="<c:url value='/butter.do?id=${after.issue.id}'/>"
              role="button"
            ></a>
            <button type="submit" class="btn btn-primary btn-lg butter-publish">
              버터 추가
            </button>
          </div>
        </div>
      </form>
    </div>
    <%@ include file="../shared/footer.jsp" %> <%@ include
    file="history-script.jsp" %>
  </body>
</html>
