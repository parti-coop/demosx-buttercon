<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <title>문화살롱 - 버터나이프크루</title>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="body-salon body-salon-form">
    <%@ include file="../shared/header.jsp" %>

    <div class="container">
      <div class="top-row clearfix">
        <div class="top-left">
          <h3 class="top-row__title">문화살롱</h3>
        </div>
      </div>

      <div class="content-container clearfix">
        <div class="demo-side">
          <h4 class="demo-side-title">프로젝트 쓰기</h4>
          <div><span class="required"> *</span>필수 입력 항목입니다.</div>
        </div>
        <div class="demo-content demo-content-right">
          <form class="demo-form" id="form-new-salon">
            <div class="form-group form-group-salon">
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
              </div>
            </div>

            <div class="form-group form-group-salon">
              <label class="demo-form-label" for="inputTeam"
                >팀 이름<span class="required"> *</span></label
              >
              <div>
                <input
                  type="text"
                  class="form-control demo-input"
                  id="inputTeam"
                  placeholder=""
                  autocomplete="off"
                  name="team"
                  data-parsley-required="true"
                  data-parsley-maxlength="100"
                />
              </div>
            </div>

            <div class="form-group form-gruop-salon">
              <label class="demo-form-label" for="category"
                >살롱 주제<span class="required"> *</span></label
              >
              <div>
                <c:set
                  var="proposalCategoryParsleyErrorsContainerId"
                  scope="page"
                  ><%= java.util.UUID.randomUUID() %></c:set
                >
                <div class="select-container">
                  <select
                    class="form-control demo-input"
                    name="category"
                    title="분류"
                    data-parsley-required="true"
                    data-parsley-errors-container="#${proposalCategoryParsleyErrorsContainerId}"
                  >
                    <option value="">살롱 주제 선택...</option>
                    <c:forEach var="category" items="${categories}">
                      <option value="${category.name}">${category.name}</option>
                    </c:forEach>
                  </select>
                </div>
                <div
                  id="${proposalCategoryParsleyErrorsContainerId}"
                  class="help-block-error-container"
                ></div>
              </div>
            </div>

            <div class="form-group form-group-salon">
              <label class="demo-form-label" for="category"
                >분야<span class="required"> *</span></label
              >
              <div>
                <c:set var="salonCategoryParsleyErrorsContainerId" scope="page"
                  ><%= java.util.UUID.randomUUID() %></c:set
                >
                <div class="select-container">
                  <select
                    class="form-control js-tagging"
                    name="issueTagNames[]"
                    multiple="multiple"
                    data-width="100%"
                  ></select>
                </div>
                <div
                  id="${salonCategoryParsleyErrorsContainerId}"
                  class="help-block-error-container"
                ></div>
              </div>
            </div>

            <div class="form-group form-group-salon">
              <label class="demo-form-label" for="inputContent"
                >내용<span class="required"> *</span></label
              >
              <div>
                <c:set var="salonContentParsleyErrorsContainerId" scope="page"
                  ><%= java.util.UUID.randomUUID() %></c:set
                >
                <div class="textarea-tinymce-container">
                  <textarea
                    class="form-control js-tinymce-editor"
                    name="content"
                    id="inputContent"
                    data-parsley-required="true"
                    data-tinymce-content-css="${pageContext.request.contextPath}/css/tinymce-content.css"
                    data-tinymce-upload-url="/ajax/mypage/files"
                    data-parsley-errors-container="#${salonContentParsleyErrorsContainerId}"
                  >
                  </textarea>
                </div>
                <div
                  id="${salonContentParsleyErrorsContainerId}"
                  class="help-block-error-container"
                ></div>
              </div>
            </div>

            <div class="form-group form-group-salon">
              <label class="demo-form-label"
                >목록썸네일<span class="required"> *</span></label
              >

              <div>
                <div class="input-group">
                  <input
                    id="img-thumbnail"
                    type="file"
                    class="js-images"
                    name="file"
                    data-url="/ajax/mypage/files"
                    data-sequential-uploads="true"
                    data-form-data='{"script": "true", "type": "EDITOR"}'
                    style="display:none;"
                  />
                  <input
                    type="text"
                    class="form-control"
                    onclick="$('#img-thumbnail').click();"
                    name="image"
                    readonly
                  />
                  <span class="input-group-btn">
                    <button
                      class="btn btn-default"
                      type="button"
                      onclick="$('#img-thumbnail').click();"
                    >
                      찾기
                    </button>
                  </span>
                </div>
                <div class="recommended">권장 이미지 사이즈 000x000px</div>
              </div>
            </div>

            <div class="form-group form-group-salon">
              <label class="demo-form-label"
                >본문커버<span class="required"> *</span></label
              >
              <div>
                <div class="input-group">
                  <input type="hidden" name="files[0][name]" value="cover" />
                  <input
                    id="img-cover"
                    type="file"
                    class="js-images"
                    name="file"
                    data-url="/ajax/mypage/files"
                    data-sequential-uploads="true"
                    data-form-data='{"script": "true", "type": "EDITOR"}'
                    style="display:none;"
                  />
                  <input
                    type="text"
                    class="form-control"
                    name="files[0][url]"
                    readonly
                    onclick="$('#img-cover').click();"
                  />
                  <span class="input-group-btn">
                    <button
                      class="btn btn-default"
                      type="button"
                      onclick="$('#img-cover').click();"
                    >
                      찾기
                    </button>
                  </span>
                </div>
                <div class="recommended">권장 이미지 사이즈 000x000px</div>
              </div>
            </div>

            <div class="form-action form-group-salon text-right ">
              <div class="inline-block">
                <button type="submit" class="btn btn-primary btn-lg btn-save">
                  등록
                </button>
                <a
                  role="button"
                  class="btn btn-default btn-lg btn-cancel"
                  href="<c:url value='/salon-list.do'/>"
                  >취소</a
                >
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
