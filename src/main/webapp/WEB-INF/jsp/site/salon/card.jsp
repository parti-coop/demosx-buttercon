<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="link" scope="page">
  <c:url value="/salon.do?id=${salon.id}" />
</c:set>
<div
  class="demo-card demo-card-salon position-relative"
  onclick="location.href = '${link}'"
>
  <section class="cover" style="background-image: url(${salon.image});">
    <div class="tags">
      <c:forEach var="issueTag" items="${salon.issueTags}">
        <span>${issueTag.name}</span>
      </c:forEach>
    </div>
    <div class="excerpt">
      ${salon.excerpt}
    </div>
  </section>
  <section class="desc">
    <div class="text-ellipse">
      <span class="category">${salon.category.name}</span>
    </div>
    <h5 class="title">${salon.title}</h5>
    <p class="team text-ellipse">${salon.team}</p>
    <div class="like">
      <i class="fa fa-heart-o"></i> 공감
      <strong>${salon.stats.likeCount}</strong>개
    </div>
  </section>
</div>
