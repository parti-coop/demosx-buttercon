<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>아이디어 - 버터나이프크루</title>
  <%@ include file="../shared/head.jsp" %>
</head>
<body class="body-proposal body-proposal-form ">
<%@ include file="../shared/header.jsp" %>

<div class="container">
  <div class="top-row clearfix">
    <div class="top-left">
      <h3 class="top-row__title">아이디어</h3>
    </div>
  </div>

  <div class="content-container clearfix">
    <div class="demo-side">
      <h4 class="demo-side-title">아이디어 수정</h4>
    </div>
    <div class="demo-content demo-content-right">
      <form class="demo-form" id="form-edit-proposal">
        <%@ include file="./guide.jsp" %>

        <input type="hidden" name="id" value="${editDto.id}">
        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="inputTitle">제목<span class="required"> *</span></label>
          <input type="text" class="form-control demo-input" id="inputTitle" placeholder="제목" autocomplete="off"
                  name="title" data-parsley-required="true" data-parsley-maxlength="100"
                  value="${editDto.title}">
        </div>

        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="category">살롱 주제<span class="required"> *</span></label>
          <c:set var="proposalCategoryParsleyErrorsContainerId" scope="page"><%= java.util.UUID.randomUUID() %></c:set>
          <div class="select-container">
            <select class="form-control demo-input" name="category" title="분류" data-parsley-required="true"  data-parsley-errors-container="#${proposalCategoryParsleyErrorsContainerId}">
                <c:forEach var="category" items="${categories}">
                  <option value="${category.name}" <c:if
                          test="${proposal.category.name eq category.name}">selected</c:if>>${category.name}</option>
                </c:forEach>
            </select>
          </div>
          <div id="${proposalCategoryParsleyErrorsContainerId}" class="help-block-error-container"></div>
        </div>

        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="inputContent">내용<span class="required"> *</span></label>
          <c:set var="proposalContentParsleyErrorsContainerId" scope="page"><%= java.util.UUID.randomUUID() %></c:set>
          <div class="textarea-tinymce-container">
            <textarea class="form-control js-tinymce-editor" name="content" id="inputContent" data-parsley-required="true" data-tinymce-content-css="${pageContext.request.contextPath}/css/tinymce-content.css" data-tinymce-upload-url="/ajax/mypage/files" data-parsley-errors-container="#${proposalContentParsleyErrorsContainerId}">
            ${editDto.content}
            </textarea>
          </div>
          <div id="${proposalContentParsleyErrorsContainerId}" class="help-block-error-container"></div>
        </div>

        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="issueTagNames[]">태그</label>
          <div class="select-container">
            <select class="form-control js-tagging" name="issueTagNames[]" multiple="multiple" data-width="100%">
              <c:forEach var="issueTag" items="${editDto.issueTags}">
                <option value="${issueTag.name}" selected>${issueTag.name}</option>
              </c:forEach>
            </select>
          </div>
        </div>

        <div class="form-action form-gruop-proposal text-right">
          <div class="inline-block">
            <a class="btn btn-default btn-lg" href="<c:url value="/proposal-list.do"/>" role="button">취소</a>
            <button type="submit" class="btn btn-primary btn-lg">아이디어 수정</button>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>
<script>
  $(function () {
    var $formEditProposal = $('#form-edit-proposal');
    $formEditProposal.parsley(parsleyConfig);
    $formEditProposal.on('submit', function (event) {
      event.preventDefault();

      var data = $formEditProposal.serializeObject();
      $.ajax({
        headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
        url: '/ajax/mypage/proposals/${editDto.id}',
        type: 'PUT',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify(data),
        success: function (data) {
          alert(data.msg);
          window.location.href = '/proposal.do?id=' + ${editDto.id};
        },
        error: function (error) {
          if (error.status === 400) {
            if (error.responseJSON.fieldErrors) {
              var msg = error.responseJSON.fieldErrors.map(function (item) {
                return item.fieldError;
              }).join('/n');
              alert(msg);
            } else alert(error.responseJSON.msg);
          } else if (error.status === 403 || error.status === 401) {
            alert('로그인이 필요합니다.');
            window.location.href = '/login.do';
          }
        }
      });
    });
  });
</script>

<%@ include file="../shared/footer.jsp" %>

</body>
</html>
