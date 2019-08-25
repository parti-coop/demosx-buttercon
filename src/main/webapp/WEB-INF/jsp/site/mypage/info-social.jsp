<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>내 정보 수정 - 버터나이프크루</title>
  <%@ include file="../shared/head.jsp" %>

  <!-- 파일 업로드 -->
  <link rel="stylesheet" type="text/css"
        href="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.22.1/css/jquery.fileupload.min.css"/>
  <script type="text/javascript"
          src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.22.1/js/vendor/jquery.ui.widget.min.js"></script>
  <script type="text/javascript"
          src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.22.1/js/jquery.iframe-transport.min.js"></script>
  <script type="text/javascript"
          src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.22.1/js/jquery.fileupload.min.js"></script>

  <!-- jquery serialize object -->
  <script type="text/javascript"
          src="https://cdnjs.cloudflare.com/ajax/libs/jquery-serialize-object/2.5.0/jquery.serialize-object.min.js"></script>
</head>
<body class="home">
<%@ include file="../shared/header.jsp" %>

<div class="container">
  <h3 class="my-page-title">마이페이지</h3>
  <div class="m-tabs-mobile">
    <form name="mypage_link-form">
      <div class="sorting-tab__select">
        <select class="form-control" name="mypage-link">
          <option value="#" selected>내 정보 수정</option>
          <option value="/mypage/proposal.do">나의 제안 활동</option>
          <option value="/mypage/vote.do">나의 투표 활동</option>
          <option value="/mypage/opinion.do">나의 의견 활동</option>
        </select>
      </div>
    </form>
  </div>
  <ul class="my-page-tabs clearfix">
    <li class="my-page-tab active"><a href="<c:url value="/mypage/info.do"/>" class="my-page-tab__link">내 정보 수정</a></li>
    <li class="my-page-tab"><a href="<c:url value="/mypage/proposal.do"/>" class="my-page-tab__link">나의 제안 활동</a>
    </li>
    <li class="my-page-tab"><a href="<c:url value="/mypage/vote.do"/>" class="my-page-tab__link">나의 투표 활동</a></li>
    <li class="my-page-tab"><a href="<c:url value="/mypage/opinion.do"/>" class="my-page-tab__link">나의 의견 활동</a></li>
  </ul>

  <div class="mypage-edit-container">
    <form>
      <div class="mypage-profile-container">
        <div class="mypage-profile-wrapper">
          <div class="profile-circle profile-circle--mypage" id="mypage-photo"
               style="background-image: url(${me.viewPhoto()})"></div>
        </div>
      </div>

      <div class="form-group form-group--demo">
        <label class="demo-form-label control-label col-sm-4">이름</label>
        <div class="col-sm-8">
          <p class="demo-form-label" style="font-weight:normal">${me.name}</p>
        </div>
      </div>
    </form>
  </div>
</div>
<script>
  $(function () {
    $('select[name=mypage-link]').change(function () {
      window.location.href = $(this).val();
    });
  });
</script>

<%@ include file="../shared/footer.jsp" %>

</body>
</html>
