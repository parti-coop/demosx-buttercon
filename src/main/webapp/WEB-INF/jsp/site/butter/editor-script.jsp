<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script>
  var butterId = "${butter.id}".length > 0 ? "${butter.id}" : "new";
  var keyName = "parti_ginger_butter_" + butterId;
  var intervalId;
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
      // autosave: {
      //   enabled: true,
      //   uniqueId: "simplemde",
      //   delay: 3000
      // },
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
    simplemde.codemirror.setOption("lineNumbers", true);
    window.simplemde = simplemde;

    if (localStorage.getItem(keyName)) {
      if (confirm("자동저장 파일을 불러오겠습니까?")) {
        simplemde.value(localStorage.getItem(keyName));
      } else {
        localStorage.removeItem(keyName);
      }
    }
    intervalId = setInterval(() => {
      localStorage.setItem(keyName, simplemde.value());
    }, 3000);
    $(".butter-cancel").click(function() {
      clearInterval(intervalId);
      localStorage.removeItem(keyName);
      console.log(localStorage.getItem(keyName));
    });
  });
</script>
