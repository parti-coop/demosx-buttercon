<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body
    class="body-butter body-butter-new body-butter-detail body-butter-edit "
  >
    <%@ include file="../shared/header.jsp" %>

    <div class="container">
      <%@ include file="title-link.jsp" %>

      <div class="clearfix">
        <div class="butter-left">
          <h4 class="butter-side-title">버터보드 수정</h4>
        </div>
        <div class="butter-right">
          <form id="form-edit-butter" class="demo-form js-form-dirrty">
            <input type="hidden" name="id" value="${butter.id}" />
            <div class="butter-header">
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
                  <c:forEach
                    var="maker"
                    items="${butter.butterMakers}"
                    varStatus="loop"
                  >
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
              <textarea id="simplemde" name="content">
${butter.content}</textarea
              >
            </div>
            <div class="form-group form-group--demo form-group-butter">
              <div class="butter-excerpt">
                <div>
                  <div class="pretty p-default p-round">
                    <input type="radio" id="minor" name="excerpt" value="" />
                    <div class="state p-warning-o">
                      <label for="minor">작은 버터 추가입니다</label>
                    </div>
                  </div>
                </div>
                <div>
                  <div class="pretty p-default p-round">
                    <input type="radio" id="major" name="excerpt" checked />
                    <div class="state p-warning-o">
                      <label for="major">큰 버터 추가입니다</label>
                    </div>
                  </div>
                </div>
                <div>
                  <input
                    type="text"
                    name="excerpt"
                    placeholder="큰 버터 추가"
                    class="excerpt-toggle"
                  />
                </div>
                <p class="excerpt-toggle">
                  <span class="butter-warning"
                    >발행 히스토리를 입력해주세요.</span
                  >
                </p>
                <div id="slack" style="display: none;">
                  <label>슬랙 url</label>
                  <input
                    type="text"
                    name="slackUrl"
                    value="${butter.slackUrl}"
                  />
                  <label>슬랙 channel</label>
                  <input
                    type="text"
                    name="slackChannel"
                    value="${butter.slackChannel}"
                  />
                  <input
                    type="hidden"
                    name="recentHistoryId"
                    value="${recentHistory.id}"
                  />
                </div>
              </div>
            </div>
            <div class="form-action form-group-butter text-right">
              <div class="butter-btn-group">
                <div>
                  <button
                    type="submit"
                    class="btn btn-primary btn-lg butter-publish"
                  >
                    버터 추가
                  </button>
                  <a
                    class="btn btn-default btn-lg butter-cancel"
                    href="<c:url value='/butter.do?id=${butter.id}'/>"
                    role="button"
                  ></a>
                </div>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
    <%@ include file="edit-script.jsp" %> <%@ include
    file="../shared/footer.jsp" %>
  </body>
</html>
