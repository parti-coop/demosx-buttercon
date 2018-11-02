<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<div class="container-fluid" id="footer">
  <div class="row">
    <div class="container">
      <div class="row">
        footer
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="modal-login">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">×</span></button>
        <h4 class="modal-title">로그인</h4>
      </div>
      <div class="modal-body">
        <form role="form" class="form-horizontal">
          <div class="form-group">
            <label for="loginEmail" class="col-sm-2 control-label">아이디(이메일)</label>
            <div class="col-sm-10">
              <input type="email" class="form-control" id="loginEmail" placeholder="Email">
            </div>
          </div>
          <div class="form-group">
            <label for="loginPassword" class="col-sm-2 control-label">Password</label>
            <div class="col-sm-10">
              <input type="password" class="form-control" id="loginPassword" placeholder="Password">
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default btn-sm pull-left" data-dismiss="modal">닫기</button>
        <button type="button" class="btn btn-primary btn-sm" id="login-post-btn">로그인</button>
      </div>
    </div>
  </div>
</div>
<c:if test="${empty loginUser}">
  <script>
    $(function () {
      var $modalLogin = $('#modal-login');
      $('.modal-login-btn').click(function (event) {
        $modalLogin.modal('show');
        event.preventDefault();
      });

      $('#login-post-btn').click(function (event) {
        var email = $('#loginEmail').val().trim();
        /*if (!email) {
          alert('이메일을 입력해 주세요.');
          return;
        }*/

        var password = $('#loginPassword').val().trim();
        if (!password) {
          alert('패스워드를 입력해 주세요.');
          return;
        }

        $.ajax({
          headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
          url: '/ajax/site/login',
          type: 'POST',
          contentType: 'application/json',
          dataType: 'json',
          data: JSON.stringify({
            id: email,
            pw: password
          }),
          success: function (data) {
            window.location.reload();
          },
          error: function (error) {
            console.log('error');
            console.log(error);
            var result = error.responseJSON;
            if (result.msg) {
              alert(result.msg);
            }
          }
        })
      });
    });
  </script>
</c:if>