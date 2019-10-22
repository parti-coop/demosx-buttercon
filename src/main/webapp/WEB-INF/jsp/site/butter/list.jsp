<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>버터나이프크루</title>
  <%@ include file="../shared/head.jsp" %>
</head>
<body class="body-butter">
<%@ include file="../shared/header.jsp" %>

<div class="container">
  <div class="top-row clearfix">
    <div class="top-left">
      <h3 class="top-row__title">버터문서</h3>
    </div>
    <div class="top-right">
      <a href="<c:url value='/butter-new.do'/>" 
        class="btn demo-btn demo-btn--primary btn-block demo-btn-butter">
        버터문서 작성
      </a>
    </div>
  </div>

  <%@include file="list-main-mine.jsp"%>
  <%@include file="list-main-other.jsp"%>
</div>

<%@ include file="../shared/footer.jsp" %>
</body>
</html>
