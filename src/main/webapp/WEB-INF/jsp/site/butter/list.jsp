<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>버터나이프크루</title>
  <%@ include file="../shared/head.jsp" %>
</head>
<body class="home">
<%@ include file="../shared/header.jsp" %>

<div class="container">
  <div class="top-row clearfix" style="border-bottom: 2px solid #212121; margin-bottom: 30px;">
    <div class="top-left">
      <h3 class="top-row__title">버터문서</h3>
    </div>
    <div class="top-right">
      <a href="<c:url value="/butter-new.do"/>" 
        class="btn demo-btn demo-btn--primary btn-block demo-btn-proposal" 
        style="font-size: 18px;padding: 12px;margin-top: 14px;">+ 버터문서 작성</a>
    </div>
  </div>

  <div class="list-container">
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
              <strong>${proposal.stats.viewCount}</strong>개</p>
              <strong>${proposal.stats.viewViewCount()}</strong>개</p>
            <p class="demo-card__info__p"><i class="xi-thumbs-up"></i> 공감
              <strong>${proposal.stats.likeCount}</strong>개</p>
              <strong>${proposal.stats.viewLikeCount()}</strong>개</p>
            <p class="demo-card__info__p"><i class="xi-message"></i> 댓글
              <strong>${proposal.stats.opinionCount}</strong>개</p>
              <strong>${proposal.stats.viewOpinionCount()}</strong>개</p>
          </div>
        </a>
      </div>
    </c:forEach>
  </div>

  <div class="list-container">
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
              <p>${item.createdBy}</p>
              <p>${item.createdDate}</p>
              <p>${item.modifiedBy}</p>
              <p>${item.modifiedDate}</p>
            </div>
          </div>
          <div class="demo-card__info">
            <p class="demo-card__info__p"><i class="xi-thumbs-up"></i> 공감
              <strong>${proposal.stats.likeCount}</strong>개</p>
            <p class="demo-card__info__p"><i class="xi-message"></i> 댓글
              <strong>${proposal.stats.opinionCount}</strong>개</p>
          </div>
        </a>
      </div>
    </c:forEach>
  </div>
</div>

<%@ include file="../shared/footer.jsp" %>
</body>
<style>
.list-container{
  padding: 10px;
}
.list-each{
  padding: 10px;
}
</style>
</html>
