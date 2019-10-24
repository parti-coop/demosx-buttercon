<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <title>버터보드 - 버터나이프크루</title>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="body-proposal body-proposal-form body-butter-new">
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
          <form class="demo-form" id="form-new-proposal">
            <!-- <input type="hidden" name="opinionType" value="DEBATE"/> -->
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
                  ></select>
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
                    <option value="${myid}" selected>${myname}</option>
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
                <textarea id="simplemde" name="content"></textarea>
              </div>
            </div>

            <div class="form-action form-group-butter">
              <input
                type="hidden"
                name="excerpt"
                placeholder="최초 버터"
                value="최초 버터"
              />
              <div class="inline-block">
                <a
                  class="btn btn-default btn-lg butter-cancel"
                  href="<c:url value='/butter-list.do'/>"
                  role="button"
                ></a>
                <button
                  type="submit"
                  class="btn btn-primary btn-lg butter-publish"
                >
                  저장하기
                </button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
    <%@ include file="new-script.jsp" %> <%@ include file="../shared/footer.jsp"
    %>
  </body>
</html>
