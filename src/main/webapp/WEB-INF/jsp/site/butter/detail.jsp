<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <title>${butter.title} - 버터나이프크루</title>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="body-butter body-butter-detail">
    <%@ include file="../shared/header.jsp" %>

    <div class="container">
      <div class="top-row clearfix">
        <div class="top-left">
          <h3 class="top-row__title">버터보드</h3>
        </div>
      </div>
      <div class="butter-container-detail">
       <%@ include file="detail-left.jsp" %>
       <%@ include file="detail-right.jsp" %>
      </div>
    </div>
    <script>
      var simplemde = new SimpleMDE({
        element: document.getElementById("simplemde"),
        toolbar: false,
        spellChecker: false
      });
      window.simplemde = simplemde;
      $(function() {
        simplemde.togglePreview();
      });
    </script>
    <%@ include file="../shared/footer.jsp" %>
  </body>
</html>
