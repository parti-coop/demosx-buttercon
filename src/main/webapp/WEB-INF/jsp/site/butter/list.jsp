<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
          <a
            href="<c:url value='/butter-new.do'/>"
            class="btn butter-btn-edit"
          >
            버터문서 작성
          </a>
        </div>
      </div>

      <div class="butter-container">
        <div class="butter-label">
          <span>내 버터문서</span
          ><i class="circle"
            >${String.valueOf(myButters != null ? myButters.size() : 0)}</i
          >
        </div>
        <div class="butter-list">
          <c:forEach var="item" items="${myButters}">
            <%@include file="list-main-each.jsp"%>
          </c:forEach>
        </div>
      </div>
      <div class="butter-container">
        <div class="butter-label">
          <span>최신 업데이트된 버터문서</span
          ><i class="circle"
            >${String.valueOf(otherButters != null ? otherButters.size() :
            0)}</i
          >
        </div>
        <div class="butter-list">
          <c:forEach var="item" items="${otherButters}">
            <%@include file="list-main-each.jsp"%>
          </c:forEach>
        </div>
      </div>
    </div>

    <%@ include file="../shared/footer.jsp" %>
  </body>
</html>
