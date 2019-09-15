<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>아이디어 - 버터나이프크루</title>
  <%@ include file="../shared/head.jsp" %>
</head>
<body class="body-proposal body-proposal-form">
<%@ include file="../shared/header.jsp" %>

<div class="container">
  <div class="top-row clearfix">
    <div class="top-left">
      <h3 class="top-row__title">아이디어</h3>
    </div>
  </div>

  <div class="content-container clearfix">
    <div class="demo-side">
      <h4 class="demo-side-title">아이디어 작성</h4>
    </div>
    <div class="demo-content demo-content-right">
      <form class="demo-form" id="form-new-proposal">
        <div class="form-warning-text">
          <p class="lead">작성 가이드</p>
          <ul class="list-unstyled">
            <li>다른 크루를 위해 본문 제일 처음에는 아이디어 내용을 요약하여 작성해주세요.</li>
            <li>아이디어의 핵심 키워드를 태그로 입력할 수 있습니다. (최대 5개까지 입력 가능)</li>
            <li><span class="text-danger">*</span> 은 필수 입력 항목입니다.</li>
          </ul>
        </div>

        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="inputTitle">제목<span class="required"> *</span></label>
          <input type="text" class="form-control demo-input" id="inputTitle" placeholder="" autocomplete="off"
                  name="title" data-parsley-required="true" data-parsley-maxlength="100">
        </div>

        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="category">분류<span class="required"> *</span></label>
          <c:set var="proposalCategoryParsleyErrorsContainerId" scope="page"><%= java.util.UUID.randomUUID() %></c:set>
          <div class="select-container">
            <select class="form-control demo-input" name="category" title="분류" data-parsley-required="true"  data-parsley-errors-container="#${proposalCategoryParsleyErrorsContainerId}">
              <option value="">살롱 주제 선택...</option>
              <c:forEach var="category" items="${categories}">
                <option value="${category.name}">${category.name}</option>
              </c:forEach>
            </select>
          </div>
          <div id="${proposalCategoryParsleyErrorsContainerId}" class="help-block-error-container"></div>
        </div>

        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="inputContent">내용<span class="required"> *</span></label>
          <c:set var="proposalContentParsleyErrorsContainerId" scope="page"><%= java.util.UUID.randomUUID() %></c:set>
          <div class="textarea-tinymce-container">
            <textarea class="form-control js-tinymce-editor" name="content" id="inputContent" data-parsley-required="true" data-tinymce-content-css="<c:url value="/css/tinymce-content.css"/>" data-tinymce-upload-url="/ajax/mypage/files" data-parsley-errors-container="#${proposalContentParsleyErrorsContainerId}">
            </textarea>
          </div>
          <div id="${proposalContentParsleyErrorsContainerId}" class="help-block-error-container"></div>
        </div>

        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="issueTagNames[]">태그</label>
          <div class="select-container">
            <select class="form-control js-tagging" name="issueTagNames[]" multiple="multiple" data-width="100%"></select>
          </div>
        </div>

        <div class="form-action form-gruop-proposal text-right ">
          <div class="inline-block">
            <a class="btn demo-submit-btn cancel-btn" href="<c:url value="/proposal-list.do"/>" role="button">취소</a>
            <button type="submit" class="demo-submit-btn demo-submit-btn--submit">아이디어 제안</button>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>
<script>
  $(function () {
    var $formNewProposal = $('#form-new-proposal');
    $formNewProposal.parsley(parsleyConfig);
    $formNewProposal.on('submit', function (event) {
      event.preventDefault();

      var data = $formNewProposal.serializeObject();
      $.ajax({
        headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
        url: '/ajax/mypage/proposals',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify(data),
        success: function (data) {
          alert(data.msg);
          $formNewProposal[0].reset();
          $formNewProposal.parsley().reset();
          window.location.href = data.url;
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
