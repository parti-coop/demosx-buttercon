<textarea id="beforeContent" style="display: none;">${before.content}</textarea>
<textarea id="afterContent" style="display: none;">${after.content}</textarea>
<script>
  $(function() {
    var initEditor = function() {
      var $target = $("#js-mergely");
      var afterContent = document.getElementById("afterContent").value;
      var beforeContent = document.getElementById("beforeContent").value;

      var docMirror = CodeMirror.MergeView($target[0], {
        value: afterContent,
        origLeft: beforeContent,
        lineNumbers: true,
        mode: "text/html",
        highlightDifferences: true,
        connect: true,
        collapseIdentical: true,
        readOnly: $target.data("read-only")
      });

      var lineWidget = document.createElement("div");
      $(lineWidget).css("width: 50px; margin: 7px; height: 14px");
      docMirror.editor().addLineWidget(57, lineWidget);

      return docMirror;
    };
    var docMirror = initEditor();

    var $formEditButter = $("#form-edit-butter");
    $formEditButter.parsley(parsleyConfig);
    $formEditButter.on("submit", function(event) {
      if ($formEditButter.data("submitting") === true) {
        return false;
      }
      event.preventDefault();
      $formEditButter.data("submitting", true);
      var data = $formEditButter.serializeObject();
      data.content = docMirror.editor().getValue();
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
          $formEditButter.data("submitting", false);
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
