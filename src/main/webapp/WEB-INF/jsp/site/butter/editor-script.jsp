<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script>
$(function() {
  function toggleFullscreen(simplemde) {
    if (simplemde.isFullscreenActive()) {
      console.log('y');
      simplemde.toggleFullScreen();
    } else {
      console.log('x');
      simplemde.toggleSideBySide();
    }
  }

  // 편집기
  var simplemde = new EasyMDE({
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
  simplemde.codemirror.setOption('lineNumbers', true);
  window.simplemde = simplemde;
});
</script>
