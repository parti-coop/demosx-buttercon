<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
  $(function() {
    function toggleFullscreen(simplemde) {
      if (simplemde.isFullscreenActive()) {
        simplemde.toggleFullScreen();
      } else {
        simplemde.toggleSideBySide();
      }
    }

    // 편집기
    var simplemde = new EasyMDE({
      element: document.getElementById("simplemde"),
      spellChecker: false,
      uploadImage: true,
      imageUploadFunction: function(file, onSuccess, onError) {
        switch (file.type) {
          case "image/jpeg":
          case "image/png":
            break;
          default:
            return onError("png, jpeg 파일만 등록 가능합니다.");
        }
        var formdata = new FormData();
        formdata.append("file", file);
        formdata.append("type", "EDITOR");
        return $.ajax({
          url: "<c:url value='/ajax/mypage/files'/>",
          type: "POST",
          data: formdata,
          headers: { "X-CSRF-TOKEN": "${_csrf.token}" },
          processData: false,
          contentType: false,
          success: function(result) {
            onSuccess(result.url);
          },
          error: function(xhr, ajaxOptions, thrownError) {
            // console.log(xhr, ajaxOptions, thrownError);
            onError(xhr.responseJSON.msg);
          }
        });
      },
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
        // "image",
        "upload-image",
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
    simplemde.codemirror.setOption("lineNumbers", true);
    window.simplemde = simplemde;
    var butterId = "${butter.id}".length > 0 ? "${butter.id}" : "new";
    var recentHistoryId =
      "${recentHistory.id}".length > 0 ? "_${recentHistory.id}" : "";
    var keyName = "parti_ginger_butter_" + butterId + recentHistoryId;

    if (localStorage.getItem(keyName)) {
      if (confirm("자동저장 파일을 불러오겠습니까?")) {
        simplemde.value(localStorage.getItem(keyName));
      } else {
        localStorage.removeItem(keyName);
      }
    }
    var intervalId = setInterval(() => {
      localStorage.setItem(keyName, simplemde.value());
      console.log("autosaving");
    }, 3000);
    $(".js-butter-cancel").click(function() {
      clearInterval(intervalId);
      localStorage.removeItem(keyName);
      console.log("canceling autosave");
    });
  });
</script>
