<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>아이디어 - 버터나이프크루</title>
  <%@ include file="../shared/head.jsp" %>
</head>
<body class="home body-proposal">
<%@ include file="../shared/header.jsp" %>

<div class="container">
  <div class="top-row clearfix">
    <div class="top-left">
      <h3 class="top-row__title">아이디어</h3>
    </div>
    <div class="top-right">
      <a href="<c:url value="/new-proposal.do"/>" class="btn demo-btn demo-btn--primary btn-block demo-btn-proposal">아이디어 제안</a>
    </div>
  </div>

  <div class="sorting-tab sorting-tab--suggest content-container clearfix">
    <form name="search">
      <div class="sorting-tab-select-row">
        <div class="sorting-tab__select sorting-tab__select-category">
          <div class="select-container">
            <select class="form-control" name="category">
              <option value="" disabled>살롱 주제 선택</option>
              <option value="">모든 살롱 주제</option>
              <c:forEach var="item" items="${categories}">
                <option value="${item.name}" <c:if test="${category eq item.name}">selected</c:if>>${item.name}</option>
              </c:forEach>
            </select>
          </div>
        </div>
        <div class="sorting-tab__select sorting-tab__select-sort">
          <div class="select-container">
            <select class="form-control" name="sort">
              <option value="latest" <c:if test="${sort eq 'latest'}">selected</c:if>>최신순</option>
              <option value="like" <c:if test="${sort eq 'like'}">selected</c:if>>공감순</option>
              <option value="opinion" <c:if test="${sort eq 'opinion'}">selected</c:if>>의견 많은 순</option>
            </select>
          </div>
        </div>
      </div>

      <div class="sorting-right-form">
        <div class="sorting-right-form__group">
          <label class="demo-form-label sr-only" for="inputSearch">이름</label>
          <input type="text" class="form-control demo-input" id="inputSearch" name="search" placeholder="검색"
                 value="${search}">
          <button type="submit" class="search-submit-btn">
            <i class="xi-search"><span class="sr-only">돋보기</span></i>
          </button>
        </div>
      </div>
    </form>
  </div>

  <div class="card-wrapper">
    <div class="row">
      <c:forEach var="item" items="${page.content}">
        <c:set var="proposal" value="${item}" scope="request"/>
        <div class="col-sm-6 demo-card-wrapper">
          <jsp:include page="card.jsp"/>
        </div>
      </c:forEach>
    </div>
  </div>

  <jsp:include page="../shared/pagination.jsp">
    <jsp:param name="totalPages" value="${page.totalPages}"/>
    <jsp:param name="current" value="${page.number + 1}"/>
  </jsp:include>
</div>

<script>
  $(function () {
    $('select[name=category]').change(function () {
      $('form[name=search]').submit();
    });
    $('select[name=sort]').change(function () {
      $('form[name=search]').submit();
    });
  });
</script>

<%@ include file="../shared/footer.jsp" %>
</body>
</html>
