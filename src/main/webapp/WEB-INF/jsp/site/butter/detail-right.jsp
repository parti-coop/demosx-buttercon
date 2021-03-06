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
            >버터 추가</a
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
  <div class="butter-left">
    <div class="butter-makers">
      <div class="butter-maker-label">버터보드 메이커</div>
      <div class="butter-maker-list-column">
        <c:forEach var="maker" items="${butter.butterMakers}">
          <div class="butter-maker-each">
            <div
              class="butter-maker-photo"
              style="background-image: url('${maker.viewPhoto()}')"
            >
            </div>
            <div class="butter-maker-name username">
              ${maker.name}
            </div>
          </div>
        </c:forEach>
      </div>
    </div>
    <div class="dropdown butter-toc">
      </button>
      <a class="btn dropdown-toggle" href="#" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        제안 목차
        <i class="xi-angle-down-thin"></i>
      </a>
      <div
        class="dropdown-menu js-dropdown-menu butter-toc-list-a"
        aria-labelledby="dropdownMenuButton"
      >
        ${toc}
      </div>
    </div>
  </div>
  <div class="butter-content simplemde-readonly">
    <div class="editor-preview editor-preview-active">${html}</div>
  </div>
  <div class="butter-contribute">
    <p>
      다양한 맛의 버터가 추가될 수록 풍성해지는 버터보드! <br />
      지금 바로 버터를 추가해주세요.
    </p>
    <p class="butter-contri-buttons">
      <a
        href="<c:url value='/butter-edit.do?id=${butter.id}'/>"
        class="btn btn-default btn-responsive-sm-md-md"
        >버터 추가하기</a
      >
      <a
        href="#댓글작성"
        class="js-focus btn btn-default btn-responsive-sm-md-md"
        data-focus="#form-opinion textarea[name=content]"
        >버터 댓글달기</a
      >
    </p>
  </div>
  <hr />
  <div class="butter-contributors">
    <div class="butter-contributor-label">
      버터를 추가한 크루입니다
    </div>
    <div class="butter-contributor-list">
      <c:forEach var="contributor" items="${contributors}">
        <div class="butter-maker-each">
          <div
            class="butter-maker-photo"
            style="background-image: url('${contributor.viewPhoto()}')"
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
      <span>버터보드 히스토리</span>
      <i class="circle"
        >${String.valueOf(histories != null ? histories.size() : 0)}</i
      >
    </div>
    <div  class="butter-history-group">
    <c:forEach var="history" items="${histories}" varStatus="status">
      <a
        class="butter-history-list ${status.index >= 3 ? 'collapse js-history-list-collapsable' : ''}"
        href="<c:url value='/butter-history.do?id=${history.id}'/>"
      >
        <div class="butter-maker-each">
          <div
            class="butter-maker-photo"
            style="background-image: url('${history.createdBy.viewPhoto()}')"
          >
          </div>
        </div>
        <div class="butter-history-right">
          <div class="butter-history-info">
            <img
              class="butter-maker-photo"
              src="${history.createdBy.viewPhoto()}"
              alt="프로필"
            />
            <span class="username">${history.createdBy.name}</span>
            <span class="butter-history-date"
              >${history.createdDate.toLocalDate()}</span
            >
          </div>
          <div class="butter-history-excerpt">
            <c:if test="${empty history.excerpt}">
              <span class="text-muted minor">작은 버터 추가</span>
            </c:if>
            ${history.excerpt}
          </div>
        </div>
      </a>
    </c:forEach>
    </div>
    <c:if test="${histories.size() > 3}">
      <div class="text-center">
        <button
          class="butter-history-more btn btn-link text-none-decoration"
          data-toggle="collapse"
          data-target=".js-history-list-collapsable"
        >
          더 보기
          <i class="xi-angle-down-thin"></i>
        </button>
      </div>
    </c:if>
  </div>
  <hr class="thick-hr" />

  <jsp:include page="../opinion/butter.jsp">
    <jsp:param name="id" value="${butter.id}" />
  </jsp:include>
  <div class="butter-container">
    <c:if test="${myButters != null && myButters.size() > 0}">
      <div class="butter-list">
        <h3>내 버터보드</h3>
        <c:forEach var="item" items="${myButters}">
          <%@include file="list-detail-each.jsp"%>
        </c:forEach>
      </div>
    </c:if>
    <c:if test="${otherButters != null && otherButters.size() > 0}">
      <div class="butter-list">
        <h3>다른 버터 보드</h3>
        <c:forEach var="item" items="${otherButters}">
          <%@include file="list-detail-each.jsp"%>
        </c:forEach>
      </div>
    </c:if>
  </div>
</div>
