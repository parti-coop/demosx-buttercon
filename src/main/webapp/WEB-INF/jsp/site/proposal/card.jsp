<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="demo-card position-relative">
  <c:if test="${param.best}">
    <div class="card-best-tag">
      <img src="<c:url value="/images/best-tag.png"/>" alt="best">
      <span>Best</span>
    </div>
  </c:if>
  <div class="demo-card__link">
    <a href="<c:url value="/proposal.do?id=${proposal.id}"/>">
      <div class="clearfix">
        <div class="demo-card__author pull-left">
          <div class="profile-circle profile-circle--title"
              style="background-image: url(${proposal.createdBy.viewPhoto()})">
            <p class="alt-text">${proposal.createdBy.name}프로필</p>
          </div>
          <p class="title-author__name">${proposal.createdBy.name}</p>
        </div>
        <div class="demo-card__date pull-right">
          <p class="title-author__date">${proposal.createdDate.toLocalDate()}</p>
        </div>
      </div>
      <div class="demo-card__contents">
        <p class="demo-card__category">${proposal.category.name}</p>
        <h5 class="demo-card__title">${proposal.title}</h5>
        <p class="demo-card__desc">${proposal.excerpt}</p>
      </div>
      <div class="demo-card__tags">
        <div>
          <c:forEach var="issueTag" items="${proposal.issueTags}">
            <a href="<c:url value="/proposal-list.do?search=%23${issueTag.name}"/>">#${issueTag.name}</a>
          </c:forEach>
        </div>
      </div>
    </a>
    <hr class="demo-card__hr"/>
    <div class="demo-card__info">
      <p class="demo-card__info__p"><i class="xi-thumbs-up"></i> 공감
        <strong>${proposal.stats.likeCount}</strong>개</p>
      <p class="demo-card__info__p"><i class="xi-message"></i> 댓글
        <strong>${proposal.stats.opinionCount}</strong>개</p>
    </div>
  </div>
</div>