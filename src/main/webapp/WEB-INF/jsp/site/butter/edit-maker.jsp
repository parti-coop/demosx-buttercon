<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <title>버터보드 - 버터나이프크루</title>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="body-butter body-butter-edit body-butter-new">
    <%@ include file="../shared/header.jsp" %>

    <div class="container">
      <div class="top-row clearfix">
        <div class="top-left">
          <h3 class="top-row__title">버터보드</h3>
        </div>
      </div>

      <div class="content-container clearfix">
        <div class="demo-side">
          <h4 class="demo-side-title">버터보드 만들기</h4>
        </div>
        <div class="demo-content demo-content-right">
          <form class="demo-form" id="form-edit-butter">
            <input type="hidden" name="id" value="${butter.id}" />
            <div class="form-group form-group--demo form-group-butter">
              <label class="demo-form-label" for="inputTitle"
                >제목<span class="required"> *</span></label
              >
              <div>
                <input
                  type="text"
                  class="form-control demo-input"
                  id="inputTitle"
                  placeholder=""
                  autocomplete="off"
                  name="title"
                  data-parsley-required="true"
                  data-parsley-maxlength="100"
                  value="${butter.title}"
                />
                <span>
                  필수 입력 항목입니다
                </span>
              </div>
            </div>

            <div class="form-group form-group--demo form-group-butter">
              <label class="demo-form-label" for="issueTagNames[]">태그</label>
              <div>
                <div class="select-container">
                  <select
                    class="form-control js-tagging"
                    name="issueTagNames[]"
                    multiple="multiple"
                    data-width="100%"
                    ><c:forEach var="issueTag" items="${butter.issueTags}">
                      <option value="${issueTag.name}" selected
                        >${issueTag.name}</option
                      >
                    </c:forEach></select
                  >
                </div>
                <span>
                  콤마 [ , ] 로 공백 없이 태그 입력
                </span>
              </div>
            </div>

            <div class="form-group form-group--demo form-group-butter">
              <label class="demo-form-label two-lines"
                >문서 메이커<br /><span>(5명)</span></label
              >
              <div>
                <div class="select-container">
                  <select
                    class="form-control maker-tagging"
                    name="makerIds[]"
                    multiple="multiple"
                    data-width="100%"
                  >
                    <c:forEach var="maker" items="${butter.butterMakers}">
                      <option value="${maker.id}" selected
                        >${maker.name}</option
                      >
                    </c:forEach>
                  </select>
                </div>
                <span>
                  콤마 [ , ] 로 공백 없이 닉네임 입력
                </span>
              </div>
            </div>

            <div class="form-group form-group--demo form-group-butter">
              <label class="demo-form-label" for="simplemde"
                >본문<span class="required">*</span></label
              >
              <div>
                <textarea id="simplemde" name="content">
${butter.content}
                </textarea>
              </div>
            </div>

            <div class="form-group form-group--demo form-group-butter">
              <label class="demo-form-label"></label>
              <div class="butter-excerpt">
                <div>
                  <div class="pretty p-default p-round">
                    <input
                      type="radio"
                      id="minor"
                      name="excerpt"
                      value="작은 버터 추가"
                    />
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
                  />
                </div>
              </div>
            </div>

            <div class="form-action form-group-butter">
              <label class="demo-form-label"></label>
              <div class="inline-block">
                <button
                  type="submit"
                  class="btn btn-lg butter-remove"
                >
                  삭제
                </button>
                <a
                  class="btn btn-default btn-lg butter-cancel"
                  href="<c:url value='/butter.do?id=${butter.id}'/>"
                  role="button"
                ></a>
                <button
                  type="submit"
                  class="btn btn-primary btn-lg butter-publish"
                >
                  저장하기
                </button>
                <input
                  type="hidden"
                  name="recentHistoryId"
                  value="${recentHistory.id}"
                />
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
