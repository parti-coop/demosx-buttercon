<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="body-butter">
    <%@ include file="../shared/header.jsp" %>

    <div class="container">
      <div class="top-row clearfix">
        <div class="top-left">
          <h3 class="top-row__title">버터보드</h3>
        </div>
        <div class="top-right">
          <a href="<c:url value='/butter-new.do'/>" class="btn butter-btn-edit">
            버터보드 만들기
          </a>
        </div>
      </div>

      <div class="butter-container">
        <div class="butter-label">
          <span>내 버터보드</span
          ><i class="circle"
            >${String.valueOf(myButters != null ? myButters.size() : 0)}</i
          >
        </div>
        <div class="butter-list">
          <c:forEach var="item" items="${myButters}">
            <%@include file="list-main-each.jsp"%>
          </c:forEach>
          <c:if test="${empty myButters or myButters.size() eq 0}">
            <div class="butter-list-each">
              <div
                style=" margin: auto;font-weight: 600; line-height: 1.44; font-size: 18px;"
              >
                새로운 버터보드를 개설해보세요.
              </div>
            </div>
          </c:if>
        </div>
      </div>
      <div class="butter-container">
        <div class="butter-label">
          <span>방금 업데이트된 보드</span
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
