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
    <div class="demo-content-right">
      <form class="demo-form" id="form-new-proposal">
        <!-- <input type="hidden" name="opinionType" value="DEBATE"/> -->
        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="inputTitle">제목<span class="required"> *</span></label>
          <input type="text" class="form-control demo-input" id="inputTitle" placeholder="" autocomplete="off"
                  name="title" data-parsley-required="true" data-parsley-maxlength="100" />
        </div>

        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="issueTagNames[]">태그</label>
          <div class="select-container">
            <select class="form-control js-tagging" name="issueTagNames[]" multiple="multiple" data-width="100%"></select>
          </div>
        </div>

        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label">문서 메이커(5명)</label>
          <div class="select-container">
            <select class="form-control maker-tagging" name="makerIds[]" multiple="multiple" data-width="100%">
              <option value="${myid}" selected>${myname}</option>
            </select>
          </div>
        </div>
        
        <div class="form-group form-group--demo form-gruop-proposal">
          <label class="demo-form-label" for="simplemde">본문*</label>
          <div style="overflow: hidden; flex: 1;">
            <textarea id="simplemde" name="content"></textarea> 
          </div>
        </div>
        

        <div class="form-action form-gruop-proposal">
          <div class="inline-block">
            <a class="btn btn-default btn-lg" href="<c:url value="/proposal-list.do"/>" role="button"></a>
            <!-- <button type="submit" class="btn btn-primary btn-lg">저장하기</button> -->
            <button type="submit" class="btn btn-primary btn-lg">발행하기</button>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>
<style>
.editor-toolbar .custom-side-by-side {
  float: right;
  width: 140px;
}
.custom-side-by-side::after {
  content: '전체화면에서 작성';
  margin-left: 10px;
}
.fullscreen .custom-side-by-side::after {
  content: '돌아가기';
}

.demo-form .form-group .demo-form-label{
  width: 200px;
}
</style>
<script>
  $(function () {
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

    var $formNewProposal = $('#form-new-proposal');
    $formNewProposal.parsley(parsleyConfig);
    $formNewProposal.on('submit', function (event) {
      event.preventDefault();

      var data = $formNewProposal.serializeObject();
      console.log(data.content);
      data.content = simplemde.value();
      $.ajax({
        headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
        url: '/ajax/butter/',
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
