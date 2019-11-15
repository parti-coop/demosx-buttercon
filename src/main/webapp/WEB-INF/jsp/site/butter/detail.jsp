<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="body-butter body-butter-detail">
    <%@ include file="../shared/header.jsp" %>

    <div class="container">
      <%@ include file="title-link.jsp" %>
      <div class="butter-container-detail">
        <%@ include file="detail-left.jsp" %> <%@ include
        file="detail-right.jsp" %>
      </div>
    </div>
   <!--  <script>
      var simplemde = new EasyMDE({
        element: document.getElementById("simplemde-view"),
        toolbar: false,
        spellChecker: false,
      });
      window.simplemde = simplemde;
      $(function() {
        simplemde.togglePreview();
        // var newHtml = $(".editor-preview-full")
        //   .html()
        //   .replace(/(#[ㄱ-ㅎ가-힣\d\w]*)/g, "<b class='tag'>$1</b>");
        // console.log(newHtml);
        // $(".editor-preview-full").html(newHtml);
      });
    </script> -->
    <%@ include file="../shared/footer.jsp" %>
  </body>
</html>
