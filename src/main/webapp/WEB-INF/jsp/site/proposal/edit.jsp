<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>아이디어 - 버터나이프크루</title>
  <%@ include file="../shared/head.jsp" %>

  <!-- jquery serialize object -->
  <script type="text/javascript"
          src="https://cdnjs.cloudflare.com/ajax/libs/jquery-serialize-object/2.5.0/jquery.serialize-object.min.js"></script>
</head>
<body class="body-proposal">
<%@ include file="../shared/header.jsp" %>

<div class="container">
  <h3 class="demo-detail-title">아이디어 수정하기</h3>

  <div class="demo-row clearfix">
    <div class="demo-content">
      <form class="demo-form" id="form-edit-proposal">
        <div class="form-input-container">
          <div class="form-warning-text">
            <p>・ 민원, 불편, 개선, 부조리 신고, 홍보 등은 해당 부서로 연락하여 주시기 바라며 본 플랫폼에서는 처리되지 않습니다.</p>
            <p>・ 제안 게시기준에 맞지 않는 부적절한 게시물은 이동 또는 삭제 조치됩니다.
              <a href="<c:url value="/copyright.do"/>">[저작권 및 컨텐츠 관련안내 바로가기]</a>
            </p>
          </div>
          <input type="hidden" name="id" value="${editDto.id}">
          <div class="form-group form-group--demo">
            <label class="demo-form-label" for="inputTitle">제목</label>
            <input type="text" class="form-control demo-input" id="inputTitle" placeholder="제목"
                   name="title" data-parsley-required="true" data-parsley-maxlength="100"
                   value="${editDto.title}">
          </div>
          <div class="form-group form-group--demo">
            <label class="demo-form-label" for="category">분류<span> *</span></label>
            <select class="form-control demo-input" name="category" title="분류" data-parsley-required="true" >
                <c:forEach var="category" items="${categories}">
                  <option value="${category.name}" <c:if
                          test="${proposal.category.name eq category.name}">selected</c:if>>${category.name}</option>
                </c:forEach>
              </select>
          </div>
          <div class="form-group form-group--demo">
            <label class="demo-form-label" for="inputContent">내용</label>
            <textarea class="form-control" name="content" id="inputContent" rows="10"
                      data-parsley-required="true">${editDto.content}</textarea>
          </div>
          <div class="form-group form-group--demo">
            <label class="demo-form-label" for="issueTagNames[]">태그</label>
            <select class="form-control js-tagging" name="issueTagNames[]" multiple="multiple">
              <c:forEach var="issueTag" items="${editDto.issueTags}">
                <option value="${issueTag.name}" selected>${issueTag.name}</option>
              </c:forEach>
            </select>
          </div>
        </div>
        <div class="form-action text-right">
          <div class="inline-block">
            <a class="btn demo-submit-btn cancel-btn" href="<c:url value="/mypage/proposal.do"/>" role="button">나의 아이디어
              목록</a>
            <button type="submit" class="demo-submit-btn demo-submit-btn--submit">수정하기</button>
          </div>
        </div>
      </form>
    </div>


    <%@include file="../shared/side.jsp" %>
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
