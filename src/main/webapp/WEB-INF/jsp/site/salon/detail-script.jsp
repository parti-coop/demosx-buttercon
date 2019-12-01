<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<link rel="stylesheet" href="https://unpkg.com/swiper/css/swiper.min.css" />
<script src="https://unpkg.com/swiper/js/swiper.min.js"></script>
<script></script>
<script>
  window.hasLoginUser = false;
  <c:if test="{not empty loginUser}">window.hasLoginUser = true;</c:if>;
</script>
<script>
  $(function() {
    /** 해더태그 목록 toc */
    var toc = "";
    var headers = $(".contents-box :header");
    headers.each(function(index) {
      el = $(this);
      el.attr("id", index);
      title = el.text();
      link = "#" + index;
      newLine =
        "<li><a class='" +
        this.tagName +
        "' href='" +
        link +
        "'>" +
        title +
        "</a></li>";
      toc += newLine;
    });
    $(".toc").html(toc);

    /** 댓글 창 숨김 */
    $(".discussion-comment-form, .js-demo-comments-container").hide();
    $("#salon-comment-btn").click(function() {
      $(this).toggleClass("btn-default btn-primary btn-outline active");
      $(".discussion-comment-form, .js-demo-comments-container").toggle();
    });

    /** 공감 버튼 */
    $(".js-salon-like-btn").click(function() {
      var hasLike = $(this).hasClass("active");
      var those = $(".js-salon-like-btn");
      var that = $(this);
      var url =
        "${pageContext.request.contextPath}/ajax/salon/${salon.id}/" +
        (hasLike ? "deselectLike" : "selectLike");
      if (!hasLoginUser) {
        if (hasLike) {
          return alert("이미 공감 하였습니다.");
        }
        url = "${pageContext.request.contextPath}/ajax/like/${salon.id}";
      }
      $.ajax({
        headers: { "X-CSRF-TOKEN": "${_csrf.token}" },
        url: url,
        type: "PUT",
        contentType: "application/json",
        dataType: "json",
        success: function(data) {
          alert(data.msg);
          var count = +$("strong", that).text();
          if (hasLike) {
            those
              .find(".fa")
              .addClass("fa-heart-o")
              .removeClass("fa-heart");
            those.removeClass("active");
            if (count !== 0) $("strong", those).text(count - 1);
          } else {
            those
              .find(".fa")
              .removeClass("fa-heart-o")
              .addClass("fa-heart");
            those.addClass("active");
            $("strong", those).text(count + 1);
          }
        },
        error: function(error) {
          if (error.status === 400) {
            if (hasLike) those.removeClass("active");
            else those.addClass("active");
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
        case "twitter":
          return window.open(
            "https://twitter.com/intent/tweet?text=버터공유&hashtags=버터나이프크루&" +
              window.location.origin +
              "/shared/${salon.id}&url=" +
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
          alert("주소가 복사되었습니다.");
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
        description: "${salon.excerpt}",
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
            mobileWebUrl: window.location.href,
            webUrl: window.location.href
          }
        }
        // ,
        // {
        //   title: "앱으로 보기",
        //   link: {
        //     mobileWebUrl: "https://developers.kakao.com",
        //     webUrl: "https://developers.kakao.com"
        //   }
        // }
      ]
    });
  });
</script>
