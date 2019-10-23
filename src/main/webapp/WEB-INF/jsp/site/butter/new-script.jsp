<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  $(function() {
    function toggleFullscreen(simplemde) {
      console.log(arguments);
      console.log(simplemde);
      console.log(simplemde.isFullscreenActive());
      if (simplemde.isFullscreenActive()) {
        simplemde.toggleFullScreen();
      } else {
        simplemde.toggleSideBySide();
      }
    }

    // 편집기
    var simplemde = new SimpleMDE({
      element: document.getElementById("simplemde"),
      toolbar: [
        "bold",
        "italic",
        "heading",
        "strikethrough",
        "|",
        "quote",
        "unordered-list",
        "ordered-list",
        "link",
        "image",
        "|",
        "preview",
        "fullscreen",
        "guide",
        {
          name: "side-by-side",
          action: toggleFullscreen,
          className: "no-disable no-mobile custom-side-by-side",
          title: "클릭"
        }
      ]
    });
    window.simplemde = simplemde;

    $(".maker-tagging").select2({
      language: "ko",
      tokenSeparators: [",", " "],
      multiple: true,
      ajax: {
        headers: { "X-CSRF-TOKEN": "${_csrf.token}" },
        url: "/ajax/butter/maker",
        type: "GET",
        contentType: "application/json",
        dataType: "json",
        processResults: function(data) {
          if (!data) {
            return;
          }
          var results = $.map(data, function(item, index) {
            return {
              id: item.id,
              text: item.name
            };
          });
          return { results };
        }
      }
    });

    var $formNewProposal = $("#form-new-proposal");
    $formNewProposal.parsley(parsleyConfig);
    $formNewProposal.on("submit", function(event) {
      event.preventDefault();

      var data = $formNewProposal.serializeObject();
      console.log(data.content);
      data.content = simplemde.value();
      $.ajax({
        headers: { "X-CSRF-TOKEN": "${_csrf.token}" },
        url: "/ajax/butter/",
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: JSON.stringify(data),
        success: function(data) {
          alert(data.msg);
          $formNewProposal[0].reset();
          $formNewProposal.parsley().reset();
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
