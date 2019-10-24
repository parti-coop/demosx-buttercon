<div class="butter-header">
  <input type="hidden" name="id" value="${butter.id}" />
  <div class="butter-tag-list">
    <c:forEach var="issueTag" items="${butter.issueTags}">
      <span
        href="<c:url value='/butter-list.do?search=%23${issueTag.name}'/>"
        class="butter-tag"
        >#${issueTag.name}</span
      >
    </c:forEach>
  </div>
  <div class="butter-title">
    <span>
      ${butter.title}
    </span>
  </div>
  <div class="butter-info">
    <div class="butter-maker-list">
      <c:forEach var="maker" items="${butter.butterMakers}" varStatus="loop">
        <c:if test="${loop.index lt 4}">
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
    <c:if
      test="${butter.butterMakers != null && butter.butterMakers.size() > 3}"
    >
      <div class="butter-extra-maker"
        >+${String.valueOf(butter.butterMakers.size() - 3)}</div
      >
    </c:if>
  </div>
</div>
<div class="butter-content">
  <textarea id="simplemde" name="content">${butter.content}</textarea>
</div>
<div class="form-action form-group-butter text-right">
  <div class="inline-block">
    <input type="hidden" name="recentHistoryId" value="${recentHistory.id}" />
    <a
      class="btn btn-default btn-lg"
      href="<c:url value='/butter-list.do'/>"
      role="button"
      >취소</a
    >
    <button type="submit" class="btn btn-primary btn-lg">
      버터 추가
    </button>
  </div>
</div>
