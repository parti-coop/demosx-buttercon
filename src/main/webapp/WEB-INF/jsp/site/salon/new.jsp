<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        <div>
          <form class="demo-form" id="form-new-salon">
            <div class="form-group form-group--demo form-gruop-salon">
              <label class="demo-form-label" for="inputTitle"
                >제목<span class="required"> *</span></label
              >
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
              <div class="js-top-image" style="display: none;">
                <img  alt="preview" />
                <input type="hidden" name="image" value="" />
              </div>
            </div>

            <div class="form-group form-group--demo form-gruop-salon">
              <label class="demo-form-label" for="category"
                >살롱 주제<span class="required"> *</span></label
              >
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

            <div class="form-group form-group--demo form-gruop-salon">
              <label class="demo-form-label" for="inputContent"
                >내용<span class="required"> *</span></label
              >
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

            <div class="form-action form-gruop-salon text-right ">
              <div class="inline-block">
                <a
                  class="btn btn-default btn-lg"
                  href="<c:url value='/salon-list.do'/>"
                  role="button"
                  >취소</a
                >
                <button type="submit" class="btn btn-primary btn-lg">
                  문화살롱 제안하기
                </button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
    <script>
      $(function() {
        var $formNewSalon = $("#form-new-salon");
        $formNewSalon.parsley(parsleyConfig);
        $formNewSalon.on("submit", function(event) {
          event.preventDefault();

          var data = $formNewSalon.serializeObject();
          $.ajax({
            headers: { "X-CSRF-TOKEN": "${_csrf.token}" },
            url: "/ajax/salon/",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: JSON.stringify(data),
            success: function(data) {
              alert(data.msg);
              $formNewSalon[0].reset();
              $formNewSalon.parsley().reset();
              window.location.href = data.url;
            },
            error: function(error) {
              if (error.status === 400) {
                if (error.responseJSON.fieldErrors) {
                  var msg = error.responseJSON.fieldErrors
                    .map(function(item) {
                      return item.fieldError;
                    })
                    .join("/n");
                  alert(msg);
                } else alert(error.responseJSON.msg);
              } else if (error.status === 403 || error.status === 401) {
                alert("로그인이 필요합니다.");
                window.location.href = "/login.do";
              }
            }
          });
        });
        $("#fileupload").fileupload({ 
          headers: { "X-CSRF-TOKEN": "${_csrf.token}" }
        }).bind('fileuploaddone', function (e, data) { 
          var url = data.result.url;
          // var img = $("<img src='"+url+"'>");
          $(".js-top-image img").attr("src", url);
          $(".js-top-image input").val(url);
          $(".js-top-image").show();
        })
      });
    </script>

    <%@ include file="../shared/footer.jsp" %>
  </body>
</html>
