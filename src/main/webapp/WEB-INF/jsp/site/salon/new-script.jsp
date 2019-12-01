<script>
  $(function() {
    var $formNewSalon = $("#form-new-salon");
    $formNewSalon.parsley(parsleyConfig);
    $formNewSalon.on("submit", function(event) {
      event.preventDefault();

      var data = $formNewSalon.serializeJSON({useIntKeysAsArrayIndex: true});
      $.ajax({
        headers: { "X-CSRF-TOKEN": "${_csrf.token}" },
        url: "/ajax/salon/",
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: JSON.stringify(data),
        success: function(data) {
          alert(data.msg);
          $formNewSalon[0].reset();
          $formNewSalon.parsley().reset();
          window.location.href = data.url;
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
    $(".js-images")
      .fileupload({
        headers: { "X-CSRF-TOKEN": "${_csrf.token}" }
      })
      .bind("fileuploaddone", function(e, data) {
        var url = data.result.url;
        var filename = data.result.filename;
        e.target.nextElementSibling.value = url;
      });
  });
</script>
