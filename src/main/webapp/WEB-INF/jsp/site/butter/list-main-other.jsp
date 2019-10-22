<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="butter-container">
  <div class="butter-label">
    <span
      >최신 업데이트된 버터문서<i
        >${String.valueOf(otherButters.size())}</i
      ></span
    >
  </div>
  <div class="butter-list">
    <c:forEach var="item" items="${otherButters}">
      <a
        href="<c:url value='/butter.do?id=${item.id}'/>"
        class="butter-list-each"
      >
        <div class="butter-each-1">
          <div class="butter-new">NEW</div>
          <div class="butter-slug">${item.id}</div>
        </div>
        <div class="butter-each-2">
          <div class="buter-tag-list">
            <c:forEach var="tag" items="${item.issueTags}">
              <span class="butter-tag">#${tag.name}</span>
            </c:forEach>
          </div>
          <div class="butter-title">${item.title}</div>
          <div class="butter-info">
            <span class="butter-date">${item.modifiedDate.toLocalDate()}</span>
            <span class="butter-date-type"
              >${item.createdDate.equals(item.modifiedDate) ? "발행됨" :
              "수정됨"}</span
            >
            <span class="butter-edit-label">수정</span>
            <span class="butter-edit-count">${item.stats.yesCount}</span>
            <span class="butter-comment-label">댓글</span>
            <span class="butter-comment-count">${item.stats.etcCount}</span>
          </div>
        </div>
        <div class="butter-each-3">
          <div class="butter-maker-list">
            <c:forEach
              var="maker"
              items="${item.butterMakers}"
              varStatus="loop"
            >
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
          <c:if test="${butterMakers != null && butterMakers.size() > 3}">
            <div>+${String.valueOf(butterMakers.size() - 3)}</div>
          </c:if>
        </div>
      </a>
    </c:forEach>
  </div>
</div>
