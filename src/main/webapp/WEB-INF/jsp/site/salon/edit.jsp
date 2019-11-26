<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <title>문화살롱 - 버터나이프크루</title>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="body-salon body-salon-form ">
    <%@ include file="../shared/header.jsp" %>

    <div class="container">
      <div class="top-row clearfix">
        <div class="top-left">
          <h3 class="top-row__title">문화살롱</h3>
        </div>
      </div>

      <div class="content-container clearfix">
        <div class="demo-side">
          <h4 class="demo-side-title">문화살롱 수정</h4>
        </div>
        <div class="demo-content demo-content-right">
          <form class="demo-form" id="form-edit-salon">
            <input type="hidden" name="id" value="${editDto.id}" />
            <div class="form-group  form-group-salon">
              <label class="demo-form-label" for="inputTitle"
                >제목<span class="required"> *</span></label
              >
              <div>
                <c:set var="salonCategoryParsleyErrorsContainerId" scope="page"
                  ><%= java.util.UUID.randomUUID() %></c:set
                >
                <input
                  type="text"
                  class="form-control demo-input"
                  id="inputTitle"
                  placeholder="제목"
                  autocomplete="off"
                  name="title"
                  data-parsley-required="true"
                  data-parsley-maxlength="100"
                  value="${editDto.title}"
                />
              </div>
            </div>

            <div class="form-group form-group-salon">
              <label class="demo-form-label" for="category"
                >살롱 주제<span class="required"> *</span></label
              >
              <div>
                <c:set var="salonContentParsleyErrorsContainerId" scope="page"
                  ><%= java.util.UUID.randomUUID() %></c:set
                >

                <div class="select-container">
                  <select
                    class="form-control demo-input"
                    name="category"
                    title="분류"
                    data-parsley-required="true"
                  >
                    <c:forEach var="category" items="${categories}">
                      <c:set var="selected" scope="page"></c:set>
                      <c:if test="${editDto.category eq category.name}">
                        <c:set var="selected" scope="page">selected</c:set>
                      </c:if>
                      <option value="${category.name}" ${selected}
                        >${category.name}</option
                      >
                    </c:forEach>
                  </select>
                </div>
              </div>
            </div>

            <div class="form-group form-group-salon">
              <label class="demo-form-label" for="issueTagNames[]">태그</label>
              <div class="select-container">
                <select
                  class="form-control js-tagging"
                  name="issueTagNames[]"
                  multiple="multiple"
                  data-width="100%"
                >
                  <c:forEach var="issueTag" items="${editDto.issueTags}">
                    <option value="${issueTag.name}" selected
                      >${issueTag.name}</option
                    >
                  </c:forEach>
                </select>
              </div>
            </div>

            <div class="form-group form-group-salon">
              <label class="demo-form-label" for="inputExcerpt"
                >프로젝트 소개<span class="required"> *</span></label
              >
              <div>
                <c:set var="salonCategoryParsleyErrorsContainerId" scope="page"
                  ><%= java.util.UUID.randomUUID() %></c:set
                >
                <input
                  type="text"
                  class="form-control demo-input"
                  id="inputExcerpt"
                  placeholder=""
                  autocomplete="off"
                  name="excerpt"
                  value="${editDto.excerpt}"
                  data-parsley-required="true"
                  data-parsley-maxlength="300"
                />
                <div
                  id="${salonCategoryParsleyErrorsContainerId}"
                  class="help-block-error-container"
                ></div>
              </div>
            </div>

            <div class="form-group  form-group-salon">
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
${editDto.content}</textarea
                  >
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
                <c:set var="salonCategoryParsleyErrorsContainerId" scope="page"
                  ><%= java.util.UUID.randomUUID() %></c:set
                >
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
                    value="${editDto.image}"
                    name="image"
                    readonly
                    data-parsley-required="true"
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
                <c:set var="salonCategoryParsleyErrorsContainerId" scope="page"
                  ><%= java.util.UUID.randomUUID() %></c:set
                >
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
                    value="${editDto.files[0].url}"
                    readonly
                    onclick="$('#img-cover').click();"
                    data-parsley-required="true"
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

            <div class="form-action form-group">
              <label class="demo-form-label"></label>
              <div
                class="butter-btn-group"
                style="display: flex; justify-content: space-between; flex-wrap: wrap;"
              >
                <button
                  type="button"
                  class="btn btn-default btn-responsive-sm-md-md btn-remove"
                  id="delete-salon-btn"
                >
                  삭제
                </button>
                <div>
                  <button type="submit" class="btn btn-primary btn-lg btn-save">
                    문화살롱 수정
                  </button>
                  <a
                    class="btn btn-default btn-lg btn-cancel"
                    href="<c:url value='/salon-list.do'/>"
                    role="button"
                    >취소</a
                  >
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
