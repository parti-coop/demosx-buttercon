<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>${salon.title} - 버터나이프크루</title>
  <%@ include file="../shared/head.jsp" %>
</head>
<body class="body-salon body-salon-detail">
<%@ include file="../shared/header.jsp" %>

<div class="container">
  <div class="top-row clearfix">
    <div class="top-left">
      <h3 class="top-row__title">아이디어</h3>
    </div>
  </div>

  <div class="content-container clearfix">
    <div class="demo-side">
      <div class="profile-circle profile-circle--title profile-circle--title-side"
        style="background-image: url('${salon.createdBy.viewPhoto()}')">
        <p class="alt-text">${salon.createdBy.name} 사진</p>
      </div>
      <div class="salon-title-author d-inline-block">
        <p class="title-author__name">${salon.createdBy.name}</p>
        <p class="title-author__date">${salon.createdDate.toLocalDate()}</p>
      </div>
    </div>
    <div class="demo-content demo-content-right">
      <div class="author-box">
        <div class="salon-title-author clearfix">
          <div class="demo-card__author pull-left">
            <div class="profile-circle profile-circle--title profile-circle--title-responsive"
                style="background-image: url('${salon.createdBy.viewPhoto()}')">
              <p class="alt-text">${salon.createdBy.name}프로필</p>
            </div>
            <p class="title-author__name">${salon.createdBy.name}</p>
          </div>
          <div class="demo-card__date pull-right">
            <p class="title-author__date">${salon.createdDate.toLocalDate()}</p>
          </div>
        </div>
      </div>
      <div class="category-box">
        <div class="category-row clearfix">
          <div class="detail-category-container">
            <h3 class="detail-category">${salon.category.name}</h2>
          </div>
          <div class="detail-copy-url">
            주소복사
            <i class="xi-share-alt"></i>
          </div>
        </div>
      </div>
      <div class="title-box">
        <div class="title-row clearfix">
          <div class="detail-title-container">
            <h2 class="detail-title">${salon.title}</h2>
          </div>
        </div>
      </div>

      <div class="contents-box">
        <div class="contents-box__contents">${salon.content}</div>

        <div class="contents-box-tags">
          <span class="contents-box-tags-lead">
            <i class="xi-tags"></i>
            태그
          </span>
          <span class="contents-box-tags-list">
            <c:forEach var="issueTag" items="${salon.issueTags}">
              <a href="<c:url value='/salon-list.do?search=%23${issueTag.name}'/>" class="contents-box-tags-link">#${issueTag.name}</a>
            </c:forEach>
          </span>
        </div>

        <div class="contents-box-controls clearfix">
          <button
              class="btn btn-responsive-sm-md-md ${salon.liked eq true ? ' btn-primary btn-outline active' : 'btn-default'}${empty loginUser ? ' show-login-modal' : ''}"
              id="salon-like-btn">
            <i class="xi-thumbs-up"></i> 공감 <strong>${salon.stats.likeCount}</strong>개
          </button>
          <button
              class="btn btn-responsive-sm-md-md btn-default"
              id="salon-comment-btn">
            <i class="xi-comment"></i> 댓글 <strong>${salon.stats.etcCount}</strong>개
          </button>
          <c:if test="${salon.createdBy.id eq loginUser.id}">
            <div class="pull-right">
              <a href="<c:url value='/salon-edit.do?id=${salon.id}'/>" class="btn btn-default btn-responsive-sm-md-md">수정</a>
              <button type="button" class="btn btn-default btn-responsive-sm-md-md" id="delete-salon-btn">삭제</button>
            </div>
          </c:if>
        </div>
      </div>

      <jsp:include page="../opinion/salon.jsp">
        <jsp:param name="id" value="${salon.id}"/>
      </jsp:include>
    </div>
  </div><!-- demo-row end  -->
</div>
<script>
$(function(){
  $(".discussion-comment-form, .js-demo-comments-container").hide();
  $('#salon-comment-btn').click(function () {
    $(this).toggleClass("btn-default btn-primary btn-outline active");
    $(".discussion-comment-form, .js-demo-comments-container").toggle();
  });
});
</script>
<c:if test="${salon.createdBy.id eq loginUser.id}">
  <script>
    $(function () {
      $('#delete-salon-btn').click(function () {
        if (!window.confirm('아이디어를 삭제하시겠습니까?')) return;

        $.ajax({
          headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
          url: '/ajax/salon/${salon.id}',
          type: 'DELETE',
          contentType: 'application/json',
          dataType: 'json',
          success: function (data) {
            alert(data.msg);
            window.location.href = '/salon-list.do';
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
      $('#salon-like-btn').click(function () {
        var hasLike = $(this).hasClass('active');
        var that = $(this);
        $.ajax({
          headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
          url: '/ajax/salon/${salon.id}/' + (hasLike ? 'deselectLike' : 'selectLike'),
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
