<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="butter-left">
  <div class="butter-makers">
    <div class="butter-maker-label">제안서 메이커</div>
    <div class="butter-maker-list-column">
      <c:forEach var="maker" items="${butter.butterMakers}">
        <div class="butter-maker-each">
          <div
            class="butter-maker-photo"
            style="background-image: url(${maker.viewPhoto()})"
          >
          </div>
          <div class="butter-maker-name username">
            ${maker.name}
          </div>
        </div>
      </c:forEach>
    </div>
  </div>
</div>
