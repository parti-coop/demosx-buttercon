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
            <div class="form-group form-group--demo form-gruop-salon">
              <label class="demo-form-label" for="inputTitle"
                >제목<span class="required"> *</span></label
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


            <div class="form-group form-group--demo form-gruop-salon">
              <label class="demo-form-label"
                >상단 이미지<span class="required"> *</span></label
              >
              <input type="file" 
              id="fileupload" 
              name="file"
              data-url="/ajax/mypage/files"
              data-sequential-uploads="true"
              data-form-data='{"script": "true", "type": "EDITOR"}'></input>
              <div class="js-top-image">
                <img src="${editDto.image}" alt="preview" />
                <input type="hidden" name="image" value="${editDto.image}" />
              </div>
            </div>

            <div class="form-group form-group--demo form-gruop-salon">
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

            <div class="form-group form-group--demo form-gruop-salon">
              <label class="demo-form-label" for="inputContent"
                >내용<span class="required"> *</span></label>
              <c:set var="salonContentParsleyErrorsContainerId" scope="page"
                ><%= java.util.UUID.randomUUID() %></c:set>
              <div class="textarea-tinymce-container">
                <textarea
                  class="form-control js-tinymce-editor"
                  name="content"
                  id="inputContent"
                  data-parsley-required="true"
                  data-tinymce-content-css="${pageContext.request.contextPath}/css/tinymce-content.css"
                  data-tinymce-upload-url="/ajax/mypage/files"
                  data-parsley-errors-container="#${salonContentParsleyErrorsContainerId}"
                >${editDto.content}</textarea>
              </div>
              <div
                id="${salonContentParsleyErrorsContainerId}"
                class="help-block-error-container"
              ></div>
            </div>

            <div class="form-action form-gruop-salon text-right">
              <div class="inline-block">
                  <button
                  type="button"
                  class="btn btn-default btn-responsive-sm-md-md"
                  id="delete-salon-btn"
                  >삭제</button
                >
                <a
                  class="btn btn-default btn-lg"
                  href="<c:url value='/salon-list.do'/>"
                  role="button"
                  >취소</a
                >
                <button type="submit" class="btn btn-primary btn-lg">
                  문화살롱 수정
                </button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
    <%@ include file="edit-script.jsp" %>
    <%@ include file="../shared/footer.jsp" %>
  </body>
</html>
