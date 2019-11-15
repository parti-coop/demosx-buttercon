<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  $(function() {
    var $formEditSalon = $("#form-edit-salon");
    $formEditSalon.parsley(parsleyConfig);
    $formEditSalon.on("submit", function(event) {
      event.preventDefault();

      var data = $formEditSalon.serializeObject();
      $.ajax({
        headers: { "X-CSRF-TOKEN": "${_csrf.token}" },
        url: "/ajax/salon/${editDto.id}",
        type: "PUT",
        contentType: "application/json",
        dataType: "json",
        data: JSON.stringify(data),
        success: function(data) {
          alert(data.msg);
          window.location.href = "/salon.do?id=" + "${editDto.id}";
        },
        error: function(error) {
          if (error.status === 400) {
            if (error.responseJSON.fieldErrors) {
              var msg = error.responseJSON.fieldErrors
                .map(function(item) {
                  return item.fieldError;
                })
                .join("/n");
              alert(msg);
            } else alert(error.responseJSON.msg);
          } else if (error.status === 403 || error.status === 401) {
            alert("로그인이 필요합니다.");
            window.location.href = "/login.do";
          }
        }
      });
    });
    $("#fileupload")
      .fileupload({
        headers: { "X-CSRF-TOKEN": "${_csrf.token}" }
      })
      .bind("fileuploaddone", function(e, data) {
        var url = data.result.url;
        // var img = $("<img src='"+url+"'>");
        $(".js-top-image img").attr("src", url);
        $(".js-top-image input").val(url);
        $(".js-top-image").show();
      });
    $("#delete-salon-btn").click(function() {
      if (!window.confirm("문화살롱를 삭제하시겠습니까?")) return;
      $.ajax({
        headers: { "X-CSRF-TOKEN": "${_csrf.token}" },
        url: "/ajax/salon/${editDto.id}",
        type: "DELETE",
        contentType: "application/json",
        dataType: "json",
        success: function(data) {
          alert(data.msg);
          window.location.href = "/salon-list.do";
        },
        error: function(error) {
          if (error.status === 400) {
            if (error.responseJSON.fieldErrors) {
              var msg = error.responseJSON.fieldErrors
                .map(function(item) {
                  return item.fieldError;
                })
                .join("/n");
              alert(msg);
            } else alert(error.responseJSON.msg);
          } else if (error.status === 403 || error.status === 401) {
            alert("로그인이 필요합니다.");
            window.location.href = "/login.do";
          }
        }
      });
    });
  });
</script>
