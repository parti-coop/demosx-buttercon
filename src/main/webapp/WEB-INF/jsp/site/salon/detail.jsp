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
        <div class="">
          <h3 class="top-row__title">
            <a href="<c:url value='/salon-list.do'/>" class="font-black"
              >문화살롱</a
            >
          </h3>
        </div>
        <section
          class="top-cover"
          style="background-image: url(${salon.files[0].url}); background-repeat: no-repeat; background-position: center; background-size: cover;"
        >
          <c:if test="${salon.createdBy.id eq loginUser.id}">
            <div class="pull-right margin-20">
              <a
                href="<c:url value='/salon-edit.do?id=${salon.id}'/>"
                class="btn btn-default btn-responsive-sm-md-md"
                >내용수정</a
              >
            </div>
          </c:if>
          <div class="demo-side"></div>
          <div class="demo-content">
            <div class="contents-box-tags">
              <span class="contents-box-tags-list">
                <c:forEach var="issueTag" items="${salon.issueTags}">
                  <a
                    href="<c:url value='/salon-list.do?search=%23${issueTag.name}'/>"
                    class="contents-box-tags-link"
                    >${issueTag.name}</a
                  >
                </c:forEach>
              </span>
            </div>
            <div class="title-row clearfix">
              <h2 class="detail-title">${salon.title}</h2>
              <h3 class="detail-teamname">팀이름 어째서 비정규직 여성</h3>
              <div class="flex margin-top-40">
                <button
                  class="${salon.liked eq true ? 'btn-outline active' : 'btn-trans'}${empty loginUser ? ' show-login-modal' : ''}"
                  id="salon-like-btn"
                >
                  <i class="fa fa-heart"></i> 공감
                  <strong>${salon.stats.likeCount}</strong>개
                </button>
                <button id="native-share" class="btn-trans mobile">
                  <i class="fa fa-share-alt"></i>
                  공유하기
                </button>
                <button class="dropdown btn-trans desktop">
                  <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    <i class="fa fa-share-alt"></i>
                    공유하기
                  </a>
                  <ul class="dropdown-menu dopdown-menu-auto">
                    <li class="dropdown-item">
                      <a href="#" class="js-share" data-mode="facebook"
                        >페이스북</a
                      >
                    </li>
                    <li class="dropdown-item">
                      <a href="#" class="js-share" data-mode="twitter"
                        >트위터</a
                      >
                    </li>
                    <li class="dropdown-item">
                      <a href="#" id="kakao-link-btn">카카오톡</a>
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
          </div>
        </section>
      </div>

      <div class="content-container clearfix">
        <div class="demo-side">
          <div class="toc">
            <ul>
              <li>1. go</li>
            </ul>
          </div>
        </div>
        <div class="demo-content demo-content-right">
          <div class="contents-box">
            <div class="contents-box__contents">${salon.content}</div>
          </div>
        </div>
      </div>
      <!-- demo-row end  -->
    </div>
    <%@ include file="detail-script.jsp" %> <%@ include
    file="../shared/footer.jsp" %>
  </body>
</html>
