<!-- mergely -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.32.0/codemirror.min.js"></script>
<link
  rel="stylesheet"
  media="all"
  href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.32.0/codemirror.css"
/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.32.0/addon/search/searchcursor.min.js"></script>
<link
  href="${pageContext.request.contextPath}/css/mergely.css?"
  rel="stylesheet"
/>
<script
  type="text/javascript"
  src="${pageContext.request.contextPath}/js/mergely.js"
></script>
<textarea id="beforeContent">${before.content}</textarea>
<textarea id="afterContent">${after.content}</textarea>
<script>
  $(function() {
    $("#mergely").mergely({
      cmsettings: { readOnly: READONLY },
      lhs: function(setValue) {
        setValue(document.getElementById("beforeContent").value);
      },
      rhs: function(setValue) {
        setValue(document.getElementById("afterContent").value);
      }
    });
    var $formEditButter = $("#form-edit-butter");
    $formEditButter.parsley(parsleyConfig);
    $formEditButter.on("submit", function(event) {
      event.preventDefault();
      var data = $formEditButter.serializeObject();
      data.content = $("#mergely").mergely("get", "rhs");
      $.ajax({
        headers: { "X-CSRF-TOKEN": "${_csrf.token}" },
        url: "/ajax/butter/${after.issue.id}",
        type: "PUT",
        contentType: "application/json",
        dataType: "json",
        data: JSON.stringify(data),
        success: function(data) {
          alert(data.msg);
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
  });
</script>
