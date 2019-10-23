<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<a href="<c:url value='/butter.do?id=${item.id}'/>" class="butter-list-each">
  <div>
    <div class="butter-title">${item.title}</div>
  </div>
  <div>
    <div class="butter-maker-list">
      <c:forEach var="maker" items="${item.butterMakers}" varStatus="loop">
        <c:if test="${loop.index < 4}">
          <div
            class="butter-maker"
            title="${maker.name}"
            style="background-image: url(${maker.viewPhoto()})"
          >
            <span>${maker.name}</span>
          </div>
        </c:if>
      </c:forEach>
    </div>
    <c:if test="${item.butterMakers != null && item.butterMakers.size() > 3}">
      <div
        class="butter-extra-maker"
        title="${item.butterMakers.subList(3, item.butterMakers.size()).stream().map(a -> a.getName()).toList().toString()}"
        >+${String.valueOf(item.butterMakers.size() - 3)}</div
      >
    </c:if>
  </div>
</a>
