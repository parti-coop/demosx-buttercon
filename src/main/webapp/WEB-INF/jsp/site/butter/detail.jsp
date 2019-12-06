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
    <%@ include file="../shared/footer.jsp" %>
  </body>
</html>
