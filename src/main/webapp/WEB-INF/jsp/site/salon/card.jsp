<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="demo-card demo-card-salon position-relative">
  <c:if test="${param.best}">
    <div class="card-best-tag">
      <img src="${pageContext.request.contextPath}/images/best-tag.png" alt="best">
      <span>Best</span>
    </div>
  </c:if>
  <div class="demo-card__link ">
    <a href="<c:url value='/salon.do?id=${salon.id}' />">
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
      <div class="demo-card__contents">
        <p class="demo-card__category">${salon.category.name}</p>
        <h5 class="demo-card__title">${salon.title}</h5>
        <p class="demo-card__desc">${salon.excerpt}</p>
      </div>
      <div class="demo-card__tags <c:if test="${salon.issueTags.size() eq 0}">demo-card__tags-empty</c:if>">
        <div>
          <c:forEach var="issueTag" items="${salon.issueTags}">
            <a href="<c:url value='/salon-list.do?search=%23${issueTag.name}'/>">#${issueTag.name}</a>
          </c:forEach>
        </div>
      </div>
    </a>
    <hr class="demo-card__hr"/>
    <div class="demo-card__info">
      <p class="demo-card__info__p"><i class="xi-thumbs-up"></i> 공감
        <strong>${salon.stats.likeCount}</strong>개</p>
      <p class="demo-card__info__p"><i class="xi-message"></i> 댓글
        <strong>${salon.stats.opinionCount}</strong>개</p>
    </div>
  </div>
</div>