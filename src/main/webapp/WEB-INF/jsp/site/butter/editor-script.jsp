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

    function syncSideBySidePreviewScroll(simplemde) {
      var cm = simplemde.codemirror;
      var preview = simplemde.codemirror.getWrapperElement().nextSibling;
      if (simplemde.options.syncSideBySidePreviewScroll) {
        simplemde.options.syncSideBySidePreviewScroll = false;
        cm.off("scroll"); // doesn't work now
        preview.onscroll = null;
      } else {
        simplemde.options.syncSideBySidePreviewScroll = true;
        simplemde.createSideBySide();
      }
    }

    function followCursor(simplemde) {
      var cm = simplemde.codemirror;
      var preview = simplemde.codemirror.getWrapperElement().nextSibling;
      // var sc = cm.getScrollInfo();
      // console.log(preview, c, sc);
      function cursorEventHandler() {
        var pos = cm.getCursor("start");
        var stat = cm.getTokenAt(pos);
        if (!stat.type) return {};
        var types = stat.type.split(" ");
        if (types.indexOf("header") > -1) {
          var string = stat.state.streamSeen.string;
          // console.log(string);
          var newString = string.substr(string.indexOf(" ")).trim();
          var hash = newString
            .replace(/\s/g, "-")
            .replace(/\%20/g, "-")
            .replace(/[\,\.\"\'\!\@\#\$\%\^\&\*\(\)\=\`\~\?]/g, "");
          var onscrollHandler = preview.onscroll;
          preview.onscroll = null;
          window.location.hash = "#" + hash;
          preview.onscroll = onscrollHandler;
          console.log(hash);
        }
      }
      cm.on("cursorActivity", cursorEventHandler);
    }

    // 편집기
    var simplemde = new EasyMDE({
      element: document.getElementById("simplemde"),
      spellChecker: false,
      uploadImage: true,
      syncSideBySidePreviewScroll: false,
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
        // {
        //   name: "syncSideBySidePreviewScroll",
        //   action: syncSideBySidePreviewScroll,
        //   className: "no-disable no-mobile fa fa-angle-double-down",
        //   title: "스크롤 동기화"
        // },
        // {
        //   name: "follow-cursor",
        //   action: followCursor,
        //   className: "fullscreen no-disable no-mobile fa fa-i-cursor",
        //   title: "커서 스크롤 동기화"
        // },
        {
          name: "side-by-side",
          action: toggleFullscreen,
          className: "no-disable no-mobile custom-side-by-side",
          title: "클릭"
        }
      ]
    });
    simplemde.codemirror.setOption("lineNumbers", true);
    followCursor(simplemde);
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
