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
      <c:forEach var="maker" items="${butter.butterMakers}">
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
    <div class="demo-content demo-content-right">
      <div>
        <c:forEach var="maker" items="${butter.butterMakers}">
        <div class="author-box">
          <div class="proposal-title-author clearfix">
            <div class="demo-card__author pull-left">
              <div class="profile-circle profile-circle--title profile-circle--title-responsive"
                  style="background-image: url(${maker.viewPhoto()})">
                <p class="alt-text">${maker.name}프로필</p>
              </div>
              <p class="title-author__name">${maker.name}</p>
            </div>
          </div>
        </div>
        </c:forEach>
      <div>
      <div class="pull-right">
        <%-- <c:if test="${butter.isMaker()}"> --%>
          <a href="<c:url value="/butter-edit.do?id=${butter.id}"/>" class="btn btn-default btn-responsive-sm-md-md">내용 수정</a>
        <%-- </c:if> --%>
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
          <textarea id="simplemde" name="content">${butter.content}</textarea>
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
        <h3>
          본 제안서에 기여해주신 분입니다.
        </h3>
        <div>
          <c:forEach var="contributor" items="${contributors}">
          <div>
            <div class="profile-circle profile-circle--title profile-circle--title-side"
              style="background-image: url(${contributor.viewPhoto()})">
              <p class="alt-text">${contributor.name} 사진</p>
            </div>
            <div class="proposal-title-author d-inline-block">
              <p class="title-author__name">${contributor.name}</p>
            </div>
          </div>
          </c:forEach>
        </div>
      <div>

      <div>
        <h2>발행이력 <strong>${String.valueOf(histories.size())}</strong></h2>
        <div>
          <c:forEach var="history" items="${histories}">
            <a href="<c:url value="/butter-history.do?id=${history.id}"/>" class="l-img-card__link">
              <div class="profile-circle profile-circle--title profile-circle--title-side"
                style="background-image: url(${history.createdBy.viewPhoto()})">
                <p class="alt-text">${history.createdBy.name} 사진</p>
              </div>
              <div class="proposal-title-author d-inline-block">
                <p class="title-author__name">${history.createdBy.name}</p>
                <p class="title-author__name">${history.createdDate.toLocalDate()}</p>
              </div>
              <div>
                ${history.excerpt}
              </div>
            </a>
          </c:forEach>
        </div>
      </div>

      <jsp:include page="../opinion/butter.jsp">
        <jsp:param name="id" value="${butter.id}"/>
      </jsp:include>


      <c:if test="${myButters != null && myButters.size() > 0 }">
      <div class="list-container">
        <h2>내 버터문서</h2>
        <c:forEach var="item" items="${myButters}">
          <div class="list-each">
            <a href="<c:url value="/butter.do?id=${item.id}"/>" class="l-img-card__link">
              <div class="l-img-card__img bg-img" style="background-image: url(${item.thumbnail})">
                <p class="sr-only">${item.title} 썸네일</p>
              </div>
              <div>
                <c:forEach var="tag" items="${item.issueTags}">
                    <span>#${tag.name}</span>
                </c:forEach>
              </div>
              <div class="l-img-card__contents">
                <h5 class="demo-card__title">${item.title}</h5>
                <p class="demo-card__desc">${item.excerpt}</p>
                <div class="demo-card__info demo-card__info--discussion">
                  <p class="demo-card__info__p">
                    <i class="xi-user-plus"></i> 참여자 
                    <c:forEach var="maker" items="${item.butterMakers}">
                      <strong>${maker.name}</strong>
                    </c:forEach>
                  </p>
                  <p>${item.createdBy.name}</p>
                  <p>${item.createdDate.toLocalDate()}</p>
                  <p>${item.modifiedBy.name}</p>
                  <p>${item.modifiedDate.toLocalDate()}</p>
                </div>
              </div>
              <div class="demo-card__info">
                <p class="demo-card__info__p"><i class="xi-thumbs-up"></i> 조회수
                  <strong>${item.stats.viewCount}</strong>개</p>
                <p class="demo-card__info__p"><i class="xi-thumbs-up"></i> 공감
                  <strong>${item.stats.likeCount}</strong>개</p>
                <p class="demo-card__info__p"><i class="xi-message"></i> 댓글
                  <strong>${item.stats.opinionCount}</strong>개</p>
              </div>
            </a>
          </div>
        </c:forEach>
      </div>
      </c:if>
      <c:if test="${otherButters != null && otherButters.size() > 0 }">
      <div class="list-container">
        <h2>최신 업데이트된 버터문서</h2>
        <c:forEach var="item" items="${otherButters}">
          <div class="list-each">
            <a href="<c:url value="/butter.do?id=${item.id}"/>" class="l-img-card__link">
              <div class="l-img-card__img bg-img" style="background-image: url(${item.thumbnail})">
                <p class="sr-only">${item.title} 썸네일</p>
              </div>
              <div>
                <c:forEach var="tag" items="${item.issueTags}">
                    <span>#${tag.name}</span>
                </c:forEach>
              </div>
              <div class="l-img-card__contents">
                <h5 class="demo-card__title">${item.title}</h5>
                <p class="demo-card__desc">${item.excerpt}</p>
                <div class="demo-card__info demo-card__info--discussion">
                  <p class="demo-card__info__p">
                    <i class="xi-user-plus"></i> 참여자 
                    <c:forEach var="maker" items="${item.butterMakers}">
                      <strong>${maker.name}</strong>
                    </c:forEach>
                  </p>
                  <p>${item.createdBy.name}</p>
                  <p>${item.createdDate.toLocalDate()}</p>
                  <p>${item.modifiedBy.name}</p>
                  <p>${item.modifiedDate.toLocalDate()}</p>
                </div>
              </div>
              <div class="demo-card__info">
                <p class="demo-card__info__p"><i class="xi-thumbs-up"></i> 조회수
                  <strong>${item.stats.viewCount}</strong>개</p>
                <p class="demo-card__info__p"><i class="xi-thumbs-up"></i> 공감
                  <strong>${item.stats.likeCount}</strong>개</p>
                <p class="demo-card__info__p"><i class="xi-message"></i> 댓글
                  <strong>${item.stats.opinionCount}</strong>개</p>
              </div>
            </a>
          </div>
        </c:forEach>
      </div>
      </c:if>
    </div>
  </div><!-- demo-row end  -->
</div>
<script>
  var simplemde = new SimpleMDE({ element: document.getElementById("simplemde"), toolbar: false });
  window.simplemde = simplemde;
  $(function () {
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
