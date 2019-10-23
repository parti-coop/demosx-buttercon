<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="butter-right">
  <div class="butter-header">
    <div class="butter-tag-list">
      <c:forEach var="issueTag" items="${butter.issueTags}">
        <span
          href="<c:url value='/butter-list.do?search=%23${issueTag.name}'/>"
          class="butter-tag"
          >#${issueTag.name}</span
        >
      </c:forEach>
      <c:if test="${butter.isMaker()}">
        <div class="pull-right">
          <a
            href="<c:url value='/butter-edit.do?id=${butter.id}'/>"
            class="btn btn-default btn-responsive-sm-md-md"
            >내용 수정</a
          >
        </div>
      </c:if>
    </div>
    <div class="butter-title">
      <span>
        ${butter.title}
      </span>
    </div>
    <div class="butter-info">
      <span class="butter-date">${butter.modifiedDate.toLocalDate()}</span>
      <span class="butter-date-type"
        >${butter.createdDate.equals(butter.modifiedDate) ? "발행됨" :
        "수정됨"}</span
      >
    </div>
  </div>
  <hr />
  <div class="butter-content">
    <textarea id="simplemde" name="content">${butter.content}</textarea>
  </div>
  <div class="butter-contribute">
    <p>
      제안 내용에 추가하고 싶은 아이디어나 정정 내용, 오탈자가 있나요?<br />
      직접 본문을 수정하거나 댓글로 기여 할 수 있습니다.
    </p>
    <p class="butter-contri-buttons">
      <a
        href="<c:url value='/butter-edit.do?id=${butter.id}'/>"
        class="btn btn-default btn-responsive-sm-md-md"
        >직접 수정으로 기여하기</a
      >
      <a href="#댓글작성" class="btn btn-default btn-responsive-sm-md-md"
        >댓글 작성으로 기여하기</a
      >
    </p>
  </div>
  <hr />
  <div class="butter-contributors">
    <div class="butter-contributor-label">
      <h4>본 제안서에 기여해주신 분입니다.</h4>
    </div>
    <div class="butter-contributor-list">
      <c:forEach var="contributor" items="${contributors}">
        <div class="butter-maker-each">
          <div
            class="butter-maker-photo"
            style="background-image: url(${contributor.viewPhoto()})"
          >
          </div>
          <div class="butter-maker-name username">
            <span>${contributor.name}</span>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>
  <hr />
  <div class="butter-histories">
    <div class="butter-history-label">
      <span>발행이력</span>
      <i class="circle"
        >${String.valueOf(histories != null ? histories.size() : 0)}</i
      >
    </div>
    <c:forEach var="history" items="${histories}">
      <a
        class="butter-history-list"
        href="<c:url value='/butter-history.do?id=${history.id}'/>"
      >
        <div class="butter-maker-each">
          <div
            class="butter-maker-photo"
            style="background-image: url(${history.createdBy.viewPhoto()})"
          >
          </div>
        </div>
        <div class="butter-history-right">
          <div class="butter-history-info">
            <span class="username">${history.createdBy.name}</span>
            <span class="butter-history-date"
              >${history.createdDate.toLocalDate()}</span
            >
          </div>
          <div class="butter-history-excerpt">
            ${history.excerpt}
          </div>
        </div>
      </a>
    </c:forEach>
  </div>
  <hr />

  <jsp:include page="../opinion/butter.jsp">
    <jsp:param name="id" value="${butter.id}" />
  </jsp:include>
  <div class="butter-container">
    <c:if test="${myButters != null && myButters.size() > 0}">
      <div class="butter-list">
        <h3>내 버터문서</h3>
        <c:forEach var="item" items="${myButters}">
          <%@include file="list-detail-each.jsp"%>
        </c:forEach>
      </div>
    </c:if>
    <c:if test="${otherButters != null && otherButters.size() > 0}">
      <div class="butter-list">
        <h3>다른 버터문서</h3>
        <c:forEach var="item" items="${otherButters}">
          <%@include file="list-detail-each.jsp"%>
        </c:forEach>
      </div>
    </c:if>
  </div>
</div>
