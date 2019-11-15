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
          <h3 class="top-row__title">
            <a href="<c:url value='/salon-list.do'/>">문화살롱</a>
          </h3>
        </div>
      </div>

      <div class="content-container clearfix">
        <div class="demo-side">
          <div
            class="profile-circle profile-circle--title profile-circle--title-side"
            style="background-image: url('${salon.createdBy.viewPhoto()}')"
          >
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
                <div
                  class="profile-circle profile-circle--title profile-circle--title-responsive"
                  style="background-image: url('${salon.createdBy.viewPhoto()}')"
                >
                  <p class="alt-text">${salon.createdBy.name}프로필</p>
                </div>
                <p class="title-author__name">${salon.createdBy.name}</p>
              </div>
              <div class="demo-card__date pull-right">
                <p class="title-author__date">
                  ${salon.createdDate.toLocalDate()}
                </p>
              </div>
            </div>
          </div>

          <div class="contents-box-tags">
            <span class="contents-box-tags-lead">
              <i class="xi-tags"></i>
              태그
            </span>

            <span class="contents-box-tags-list">
              <c:forEach var="issueTag" items="${salon.issueTags}">
                <a
                  href="<c:url value='/salon-list.do?search=%23${issueTag.name}'/>"
                  class="contents-box-tags-link"
                  >#${issueTag.name}</a
                >
              </c:forEach>
            </span>
          </div>
          <div class="title-box">
            <div class="title-row clearfix">
              <div
                class="detail-title-container"
                style="background-image: url(${salon.image}); background-repeat: no-repeat;"
              >
                <h2 class="detail-title">${salon.title}</h2>
              </div>
              <button
                class="btn btn-responsive-sm-md-md ${salon.liked eq true ? ' btn-primary btn-outline active' : 'btn-default'}${empty loginUser ? ' show-login-modal' : ''}"
                id="salon-like-btn"
              >
                <i class="xi-thumbs-up"></i> 공감
                <strong>${salon.stats.likeCount}</strong>개
              </button>
              <button id="native-share">모바일 네이티브 공유</button>
              <button class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                  공유
                  <i class="xi-angle-down-thin"></i>
                </a>
                <ul class="dropdown-menu dopdown-menu-auto">
                  <li class="dropdown-item">
                    <a href="#" class="js-share" data-mode="facebook"
                      >페이스북</a
                    >
                  </li>
                  <li class="dropdown-item">
                    <a href="#" class="js-share" data-mode="twitter">트위터</a>
                  </li>
                  <li class="dropdown-item">
                    <a href="#" class="js-share" data-mode="kakao">카카오톡</a>
                  </li>
                  <li class="dropdown-item">
                    <a class="detail-copy-url js-detail-copy-url">
                      url복사
                      <i class="xi-share-alt"></i>
                    </a>
                  </li>
                </ul>
              </button>
            </div>
          </div>

          <div class="contents-box">
            <div class="contents-box__contents">${salon.content}</div>

            <div class="contents-box-controls clearfix">
              <button
                class="btn btn-responsive-sm-md-md btn-default"
                id="salon-comment-btn"
              >
                <i class="xi-comment"></i> 댓글
                <strong>${salon.stats.etcCount}</strong>개
              </button>
              <c:if test="${salon.createdBy.id eq loginUser.id}">
                <div class="pull-right">
                  <a
                    href="<c:url value='/salon-edit.do?id=${salon.id}'/>"
                    class="btn btn-default btn-responsive-sm-md-md"
                    >수정</a
                  >
                </div>
              </c:if>
            </div>
          </div>

          <jsp:include page="../opinion/salon.jsp">
            <jsp:param name="id" value="${salon.id}" />
          </jsp:include>
        </div>
      </div>
      <!-- demo-row end  -->
    </div>
    <%@ include file="detail-script.jsp" %> <%@ include
    file="../shared/footer.jsp" %>
  </body>
</html>
