<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>버터나이프크루</title>
  <%@ include file="../shared/head.jsp" %>
</head>
<body class="body-proposal body-proposal-detail">
<%@ include file="../shared/header.jsp" %>

<div class="container">
  <div class="top-row clearfix">
    <div class="top-left">
      <h3 class="top-row__title">N개의 공론장 - 서울의 청년커뮤니티 작동에 관한 탐색적 연구</h3>
    </div>
  </div>
  <div class="">
    <div class="mergely-resizer">
      <div id="mergely"></div>
    </div>
  </div>
  <div>
    ${after.excerpt}
  </div>
</div>
<%@ include file="../shared/footer.jsp" %>
<script>
$(function () {
  $('#mergely').mergely({
        lhs: function(setValue) {
            setValue(`${before.content}`);
        },
        rhs: function(setValue) {
            setValue(`${after.content}`);
        }
    });
});
</script>
</body>
</html>
