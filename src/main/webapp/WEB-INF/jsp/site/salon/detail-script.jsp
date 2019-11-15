<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
  $(function() {
    $(".discussion-comment-form, .js-demo-comments-container").hide();
    $("#salon-comment-btn").click(function() {
      $(this).toggleClass("btn-default btn-primary btn-outline active");
      $(".discussion-comment-form, .js-demo-comments-container").toggle();
    });
    $("#salon-like-btn").click(function() {
      var hasLike = $(this).hasClass("active");
      var that = $(this);
      $.ajax({
        headers: { "X-CSRF-TOKEN": "${_csrf.token}" },
        url:
          "${pageContext.request.contextPath}/ajax/salon/${salon.id}/" +
          (hasLike ? "deselectLike" : "selectLike"),
        type: "PUT",
        contentType: "application/json",
        dataType: "json",
        success: function(data) {
          alert(data.msg);
          var count = +$("strong", that).text();
          if (hasLike) {
            that.removeClass("active");
            that.removeClass("btn-primary");
            that.removeClass("btn-outline");
            that.addClass("btn-default");
            if (count !== 0) $("strong", that).text(count - 1);
          } else {
            that.addClass("active");
            that.addClass("btn-primary");
            that.addClass("btn-outline");
            that.removeClass("btn-default");
            $("strong", that).text(count + 1);
          }
        },
        error: function(error) {
          if (error.status === 400) {
            if (hasLike) that.removeClass("active");
            else that.addClass("active");
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
    $(".js-share").click(function share() {
      var mode = $(this).data("mode");
      var encodedHref = window.encodeURIComponent(window.location.href);
      console.log(encodedHref);
      switch (mode) {
        case "facebook":
          return window.open(
            "https://www.facebook.com/dialog/share?app_id=2383023648400938&display=popup&redirect_uri=" +
              window.location.origin +
              "/shared/${salon.id}&href=" +
              encodedHref
          );
        default:
          console.log(this);
      }
    });
    $("#native-share").click(function() {
      if (navigator.share) {
        navigator
          .share({
            title: "${salon.title}",
            text: "버터나이프크루",
            url: window.location.href
          })
          .then(() => console.log("Successful share"))
          .catch(error => console.log("Error sharing", error));
      }
    });
    $(".js-detail-copy-url").click(function() {
      navigator.clipboard
        .writeText(window.location.href)
        .then(() => {
          console.log("Text copied to clipboard");
        })
        .catch(err => {
          // This can happen if the user denies clipboard permissions:
          console.error("Could not copy text: ", err);
        });
    });
    Kakao.init("616b92217f3fe9b95560ede9e28fb756");
    Kakao.Link.createDefaultButton({
      container: "#kakao-link-btn",
      objectType: "feed",
      content: {
        title: "${salon.title}",
        description: "",
        imageUrl: "${salon.image}",
        link: {
          mobileWebUrl: window.location.href,
          webUrl: window.location.href
        }
      },
      social: {
        likeCount: Number("${salon.stats.likeCount}"),
        commentCount: Number("${salon.stats.etcCount}"),
        sharedCount: Number("${salon.stats.noCount}")
      },
      buttons: [
        {
          title: "웹으로 보기",
          link: {
            mobileWebUrl: "https://developers.kakao.com",
            webUrl: "https://developers.kakao.com"
          }
        },
        {
          title: "앱으로 보기",
          link: {
            mobileWebUrl: "https://developers.kakao.com",
            webUrl: "https://developers.kakao.com"
          }
        }
      ]
    });
  });
</script>
