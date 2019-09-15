<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>내 정보 수정 - 버터나이프크루</title>
  <%@ include file="../shared/head.jsp" %>
</head>
<body class="home">
<%@ include file="../shared/header.jsp" %>

<div class="container">
  <h3 class="my-page-title">${loginUser.name}</h3>
  <%-- <div class="m-tabs-mobile">
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
  </ul> --%>

  <div class="mypage-edit-container">
    <form name="mypage-info" id="form-mypage">
      <div class="mypage-profile-container">
        <div class="mypage-profile-wrapper">
          <div class="profile-circle profile-circle--mypage" id="mypage-photo"
               style="background-image: url(${me.viewPhoto()})"></div>
          <span class="profile-edit-btn fileinput-button" style="position:absolute">
              <i class="xi-camera-o"></i>
              <input id="thumbnail-upload-input" type="file" name="file" accept="image/*">
          </span>
          <img src="<c:url value="/images/loading.gif"/>" height="20" id="thumbnail-progress" class="hidden">
        </div>
        <p class="mypage-profile-helper-text">※ 파일 용량 1MB제한 (이미지크기 144X144)</p>
        <p class="mypage-profile-helper-text">※ 업로드 하신 프로필 사진이 음란/불법/폭력 및 기타 사유로 문제가 되는 경우, 삭제 될 수 있습니다.</p>
        <input type="hidden" name="photo" value="${me.photo}">
      </div>

      <div class="form-group form-group--demo">
        <label class="demo-form-label" for="inputName">이름</label>
        <input type="text" class="form-control demo-input" name="name" id="inputName" placeholder="이름"
               autocomplete="off" value="${me.name}" data-parsley-required="true">
      </div>

      <div class="sing-action">
        <button type="submit" class="btn demo-btn demo-btn--primary btn-sign">저장하기</button>
      </div>
    </form>

    <hr>

    <c:if test="${me.getProvider() eq 'email'}">
      <div class="panel-group panel-group--mypage">
        <a class="blue-link" href="<c:url value="/mypage/change-password.do"/>">비밀번호 변경하기</a>
      </div>
    </c:if>

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

<script>
  $(function () {
    var $formMypage = $('#form-mypage');
    $formMypage.parsley(parsleyConfig);
    $formMypage.on("submit", function (event) {
      event.preventDefault();
      var data = $formMypage.serializeObject();
      $.ajax({
        headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
        url: '/ajax/mypage/info',
        type: 'PUT',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify(data),
        success: function (data) {
          alert(data.msg);
          window.location.reload();
        },
        error: function (error) {
          if (error.status === 400) {
            if (error.responseJSON.fieldErrors) {
              var passwordError = '';
              var msg = error.responseJSON.fieldErrors.map(function (item) {
                if(item.fieldName === 'password') {
                  passwordError = item.fieldError;
                }
                return item.fieldError;
              }).join('/n');
              if(passwordError) {
                $('#password-group').addClass('has-error');
                $('#password-error').text(passwordError);
              } else {
                alert(msg);
              }
            } else alert(error.responseJSON.msg);
          } else if (error.status === 403 || error.status === 401) {
            alert('로그인이 필요합니다.');
            window.location.href = '/login.do';
          }
        }
      });
    });

    $('#thumbnail-upload-input').fileupload({
      headers: {
        'X-CSRF-TOKEN': '${_csrf.token}'
      },
      url: '/ajax/mypage/files',
      dataType: 'json',
      done: function (e, data) {
        $('#thumbnail-progress').addClass('hidden');
        $('input[name=photo]').val(data.result.url);
        $('#mypage-photo').css('background-image', 'url(' + data.result.url + ')');
      },
      progressall: function (e, data) {
        $('#thumbnail-progress').removeClass('hidden');
      },
      fail: function (e, data) {
        $('#thumbnail-progress').addClass('hidden');
        if(data.jqXHR.status === 403) {
          alert('로그인이 필요합니다.');
          window.location.reload();
          return;
        }
        alert(data.jqXHR.responseJSON.msg);
      }
    }).prop('disabled', !$.support.fileInput)
      .parent().addClass($.support.fileInput ? undefined : 'disabled');
  });
</script>
</body>
</html>
