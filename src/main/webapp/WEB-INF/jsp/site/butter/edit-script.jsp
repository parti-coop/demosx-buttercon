<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- SimpleMDE -->
<link
  rel="stylesheet"
  href="https://cdn.jsdelivr.net/simplemde/latest/simplemde.min.css"
/>
<script src="https://cdn.jsdelivr.net/simplemde/latest/simplemde.min.js"></script>

<script>
  function setSlack(url, channel) {
    $("input[name='slackUrl']").val(url);
    $("input[name='slackChannel']").val(channel);
  }
  function showSlack() {
    $("#slack").show();
  }
  $(function() {
    $("input[name='excerpt'][type='radio']").change(function(e) {
      $("input[name='excerpt'][type='text']").toggle();
      $("input[name='excerpt'][type='text']").prop("disabled", function(i, v) { return !v; });
    });
    function toggleFullscreen(simplemde) {
      if (simplemde.isFullscreenActive()) {
        simplemde.toggleFullScreen();
      } else {
        simplemde.toggleSideBySide();
      }
    }

    // 편집기
    var simplemde = new SimpleMDE({
      element: document.getElementById("simplemde"),
      spellChecker: false,
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

    var $formEditButter = $("#form-edit-butter");
    $formEditButter.parsley(parsleyConfig);
    $formEditButter.on("submit", function(event) {
      event.preventDefault();
      var data = $formEditButter.serializeObject();
      if (data.excerpt == "" && !$("input[type='text'][name='excerpt']").prop('disabled')) {
        alert("수정내용을 입력해주세요");
        $("input[type='text'][name='excerpt']").focus();
        return;
      }
      $.ajax({
        headers: { "X-CSRF-TOKEN": "${_csrf.token}" },
        url: "/ajax/butter/${butter.id}",
        type: "PUT",
        contentType: "application/json",
        dataType: "json",
        data: JSON.stringify(data),
        success: function(data) {
          alert(data.msg);
          // window.location.href = '/butter.do?id=' + ${butter.id};
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

    $("#btn-butter-delete").one("click", function(e) {
      $.ajax({
        headers: { "X-CSRF-TOKEN": "${_csrf.token}" },
        url: "/ajax/butter/${butter.id}",
        type: "DELETE",
        contentType: "application/json",
        dataType: "json",
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
