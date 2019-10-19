<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>${butter.title} - 버터나이프크루</title>
  <%@ include file="../shared/head.jsp" %>
</head>
<body class="body-proposal body-proposal-detail">
<%@ include file="../shared/header.jsp" %>

<div class="container">
  <div class="top-row clearfix">
    <div class="top-left">
      <h3 class="top-row__title">제안서</h3>
    </div>
  </div>

  <div class="content-container clearfix">
    <div class="demo-side">
      <c:forEach var="maker" items="${item.butterMakers}">
      <div>
        <div class="profile-circle profile-circle--title profile-circle--title-side"
          style="background-image: url(${maker.viewPhoto()})">
          <p class="alt-text">${maker.name} 사진</p>
        </div>
        <div class="proposal-title-author d-inline-block">
          <p class="title-author__name">${maker.name}</p>
        </div>
      </div>
      </c:forEach>
    </div>
    <div class="">
      <div class="author-box">
        <c:forEach var="maker" items="${item.butterMakers}">
        <div class="proposal-title-author clearfix">
          <div class="demo-card__author pull-left">
            <div class="profile-circle profile-circle--title profile-circle--title-responsive"
                style="background-image: url(${maker.viewPhoto()})">
              <p class="alt-text">${maker.name}프로필</p>
            </div>
            <p class="title-author__name">${maker.name}</p>
          </div>
        </div>
        </c:forEach>
      </div>
      <div class="pull-right">
        <c:if test="${butter.isMaker()}">
            <a href="<c:url value="/butter-edit.do?id=${butter.id}"/>" class="btn btn-default btn-responsive-sm-md-md">내용 수정</a>
        </c:if>
      </div>
      <div class="contents-box-tags">
        <span class="contents-box-tags-list">
          <c:forEach var="issueTag" items="${butter.issueTags}">
            <a href="<c:url value="/butter-list.do?search=%23${issueTag.name}"/>" class="contents-box-tags-link">#${issueTag.name}</a>
          </c:forEach>
        </span>
      </div>
      <div class="title-box">
        <div class="title-row clearfix">
          <div class="detail-title-container">
            <h2 class="detail-title">${butter.title}</h2>
          </div>
        </div>
      </div>

      <div class="contents-box">
        <div class="contents-box__contents">
          <textarea id="simplemde"></textarea>
        </div>
      </div>
      <div>
        <p>
          제안 내용에 추가하고 싶은 아이디어나 정정 내용, 오탈자가 있나요?<br />
          직접 본문을 수정하거나 댓글로 기여 할 수 있습니다.
        </p>
        <a href="<c:url value="/butter-edit.do?id=${butter.id}"/>" class="btn btn-default btn-responsive-sm-md-md">직접 수정으로 기여하기</a>
        <a href="#댓글작성">댓글 작성으로 기여하기</a>
      </div>

      <div>
        <div>
          본 제안서에 기여해주신 분입니다.
        </div>
        <div>
          <c:forEach var="maker" items="${item.butterMakers}">
          <div>
            <div class="profile-circle profile-circle--title profile-circle--title-side"
              style="background-image: url(${maker.viewPhoto()})">
              <p class="alt-text">${maker.name} 사진</p>
            </div>
            <div class="proposal-title-author d-inline-block">
              <p class="title-author__name">${maker.name}</p>
            </div>
          </div>
          </c:forEach>
        </div>
      <div>

      <jsp:include page="../opinion/butter.jsp">
        <jsp:param name="id" value="${butter.id}"/>
      </jsp:include>
    </div>
  </div><!-- demo-row end  -->
</div>
<script>
  var simplemde = new SimpleMDE({ element: document.getElementById("simplemde"), toolbar: false });
  window.simplemde = simplemde;
  $(function () {
    simplemde.value(`${butter.content}`);
    simplemde.togglePreview();
  });
</script>
<c:if test="${butter.createdBy.id eq loginUser.id}">
  <script>
    $(function () {
      $('#delete-proposal-btn').click(function () {
        if (!window.confirm('아이디어를 삭제하시겠습니까?')) return;

        $.ajax({
          headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
          url: '/ajax/mypage/proposals/${butter.id}',
          type: 'DELETE',
          contentType: 'application/json',
          dataType: 'json',
          success: function (data) {
            alert(data.msg);
            window.location.href = '/proposal-list.do';
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
</c:if>
<c:if test="${not empty loginUser}">
  <script>
    $(function () {
      $('#proposal-like-btn').click(function () {
        var hasLike = $(this).hasClass('active');
        var that = $(this);
        $.ajax({
          headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
          url: '/ajax/mypage/proposals/${butter.id}/' + (hasLike ? 'deselectLike' : 'selectLike'),
          type: 'PUT',
          contentType: 'application/json',
          dataType: 'json',
          success: function (data) {
            alert(data.msg);
            var count = +$('strong', that).text();
            if (hasLike) {
              that.removeClass('active');
              that.removeClass('btn-primary');
              that.removeClass('btn-outline');
              that.addClass('btn-default');
              if (count !== 0) $('strong', that).text(count - 1);
            }
            else {
              that.addClass('active');
              that.addClass('btn-primary');
              that.addClass('btn-outline');
              that.removeClass('btn-default');
              $('strong', that).text(count + 1);
            }
          },
          error: function (error) {
            if (error.status === 400) {
              if (hasLike) that.removeClass('active');
              else that.addClass('active');
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
</c:if>
<%@ include file="../shared/footer.jsp" %>

</body>
</html>
