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
      <h4 class="demo-side-title">제안서 수정</h4>
    </div>
    <div class="demo-content demo-content-right">
      <form class="demo-form" id="form-edit-proposal">
        <input type="hidden" name="id" value="${butter.id}">
        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="inputTitle">제목<span class="required"> *</span></label>
          <c:if test="${butter.isMaker()}">
          <input type="text" class="form-control demo-input" id="inputTitle" placeholder="제목" autocomplete="off"
              name="title" data-parsley-required="true" data-parsley-maxlength="100"
              value="${butter.title}" />
          </c:if>
          <c:if test="${!butter.isMaker()}">
          <h3>${butter.title}</h3>
          </c:if>
        </div>

        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="issueTagNames[]">태그</label>
          <c:if test="${butter.isMaker()}">
          <div class="select-container">
            <select class="form-control js-tagging" name="issueTagNames[]" multiple="multiple" data-width="100%">
              <c:forEach var="issueTag" items="${butter.issueTags}">
                <option value="${issueTag.name}" selected>${issueTag.name}</option>
              </c:forEach>
            </select>
          </div>
          </c:if>
          <c:if test="${!butter.isMaker()}">
          <div>
            <c:forEach var="issueTag" items="${butter.issueTags}">
              <h4>#${issueTag.name}</h4>
            </c:forEach>
          </div>
          </c:if>
        </div>

        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label">문서 메이커(5명)</label>
          <c:if test="${butter.isMaker()}">
          <div class="select-container">
            <select class="form-control maker-tagging" name="makerIds[]" multiple="multiple" data-width="100%">
              <c:forEach var="maker" items="${butter.butterMakers}">
              <option value="${maker.id}" selected>${maker.name}</option>
              </c:forEach>
            </select>
          </div>
          </c:if>
          <c:if test="${!butter.isMaker()}">
          <div>
            <c:forEach var="maker" items="${butter.butterMakers}">
              <h5>${maker.name}</h5>
            </c:forEach>
          </div>
          </c:if>
        </div>

        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="simplemde">본문*</label>
          <div style="overflow: hidden; flex: 1;">
            <textarea id="simplemde" name="content">${butter.content}</textarea> 
          </div>
        </div>

        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="simplemde"></label>
          <div style="overflow: hidden; flex: 1;">
            <input type="radio" id="minor" name="excerpt" value="자잘한 수정"  /><label for="minor">자잘한 수정입니다.</label>
            <input type="radio" id="major" name="excerpt" checked /><label for="major">큰 수정입니다.  (100자 이내 작성) </label>
            <input type="text" name="excerpt" placeholder="수정 요약 작성" />
          </div>
        </div>

        <div class="form-action form-gruop-proposal text-right">
          <div class="inline-block">
            <a class="btn btn-default btn-lg" href="<c:url value="/butter-list.do"/>" role="button">취소</a>
            <button type="submit" class="btn btn-primary btn-lg">${butter.isMaker() ? '발행' : '기여'}</button>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>
<script>
  $(function () {
    $("input[name='excerpt'][type='radio']").change(e=>{
      $("input[name='excerpt'][type='text']").toggle();
      $("input[name='excerpt'][type='text']").prop('disabled', (i, v) => !v);
    });
    function toggleFullscreen(simplemde){
      console.log(arguments);
      console.log(simplemde);
      console.log(simplemde.isFullscreenActive());
      if(simplemde.isFullscreenActive()){
        simplemde.toggleFullScreen();
      }else{
        simplemde.toggleSideBySide();
      }
    }

    // 편집기
    var simplemde = new SimpleMDE({ 
      element: document.getElementById("simplemde"), 
      toolbar: ["bold", "italic", "heading", "strikethrough", "|", 
        "quote","unordered-list","ordered-list","link","image","|","preview",
        "fullscreen","guide",
      {
        name: "side-by-side",
        action: toggleFullscreen,
        className: "no-disable no-mobile custom-side-by-side",
        title: "클릭",
      }
    ] 
    });
    window.simplemde = simplemde;

    $('.maker-tagging').select2({
      language: "ko",
      tokenSeparators: [',', ' '],
      multiple: true,
      ajax: {
        headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
        url: '/ajax/butter/maker',
        type: 'GET',
        contentType: 'application/json',
        dataType: 'json',
        processResults: function (data) {
          if(!data) {
            return;
          }
          var results = $.map(data, function(item, index) {
            return {
              'id': item.id,
              'text': item.name,
            };
          });
          return { results };
        },
      }
    });

    var $formEditProposal = $('#form-edit-proposal');
    $formEditProposal.parsley(parsleyConfig);
    $formEditProposal.on('submit', function (event) {
      event.preventDefault();

      var data = $formEditProposal.serializeObject();
      $.ajax({
        headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
        url: '/ajax/butter/${butter.id}',
        type: 'PUT',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify(data),
        success: function (data) {
          alert(data.msg);
          window.location.href = '/butter.do?id=' + ${butter.id};
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
