<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <title>버터나이프크루</title>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="body-butter-new">
    <%@ include file="../shared/header.jsp" %>

    <div class="container">
      <div class="top-row clearfix">
        <div class="top-left">
          <h3 class="top-row__title">
            N개의 공론장 - 서울의 청년커뮤니티 작동에 관한 탐색적 연구
          </h3>
        </div>
      </div>
      <div class="mergely">
        <div class="mergely-resizer">
          <div id="mergely"></div>
        </div>
      </div>
      <div class="mergely-excerpt">
        <input type="text" value="${before.excerpt}" disabled />
        <input type="text" name="excerpt" value="${after.excerpt}" />
      </div>
      <form class="demo-form" id="form-edit-butter">
        <input type="hidden" name="id" value="${butterId}" />
        <div class="form-action form-gruop-proposal text-right">
          <div class="inline-block">
            <input type="hidden" name="recentHistoryId" value="${before.id}" />
            <a
              class="btn btn-default btn-lg"
              href="<c:url value='/butter-list.do'/>"
              role="button"
              >취소</a
            >
            <button type="submit" class="btn btn-primary btn-lg">
              버터추가
            </button>
          </div>
        </div>
      </form>
    </div>
    <%@ include file="../shared/footer.jsp" %>
    <script>
      $(function() {
        $("#mergely").mergely({
          lhs: function(setValue) {
            setValue(`${before.content}`);
          },
          rhs: function(setValue) {
            setValue(`${after.content}`);
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
            url: "/ajax/butter/${butterId}",
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
  </body>
</html>
