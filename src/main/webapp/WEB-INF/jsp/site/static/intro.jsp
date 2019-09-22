<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>버터나이프크루</title>
  <%@ include file="../shared/head.jsp" %>
</head>
<body class="body-intro">
<%@ include file="../shared/header.jsp" %>

<section>
  <img src="${pageContext.request.contextPath}/images/intro-key-visual.png" style="width: 100%; margin-top: -20px;">
  <div class="container">
  </div>
</section>

<div class="container">
  <div class="top-row clearfix">
    <div class="top-left">
      <h3 class="top-row__title">버터나이프크루</h3>
    </div>
  </div>

  <div class="content-container clearfix">
    <div class="demo-side">
      &nbsp;
    </div>
    <div class="demo-content demo-content-right">
      <h3 class="demo-detail-title demo-detail-title-noborder">나의 삶은 달라지고 있고, 우리가 변화의 흐름을 만든다.</h3>
      <div class="terms-wrapper">
        <p class="normal">
          버터나이프크루는
          <br>
          청년의 달라진 삶에 필요한 정책을 제안(정책살롱)하고
          <br class="hidden-xs"/>
          청년의 달라진 삶을 반영하는 문화혁신사업(문화살롱)을 진행하는 청년참여플랫폼입니다.
        </p>
      </div>
      <div class="row box-container">
        <div class="col-lg-3 col-md-6 col-sm-6 col-xs-6 box-wrapper">
          <div class="box">
            청년으로서
            <br>
            내 삶을 들여다보고
          </div>
        </div>
        <div class="col-lg-3 col-md-6 col-sm-6 col-xs-6 box-wrapper">
          <div class="box">
            변화된 우리의 삶을
            <br>
            이야기하고
          </div>
        </div>
        <div class="col-lg-3 col-md-6 col-sm-6 col-xs-6 box-wrapper">
          <div class="box">
            우리가 살고 싶은
            <br>
            삶에 대해
          </div>
        </div>
        <div class="col-lg-3 col-md-6 col-sm-6 col-xs-6 box-wrapper">
          <div class="box">
            주도적으로
            <br>
            목소리를 낸다
          </div>
        </div>
      </div>
      <div class="terms-wrapper">
        <p class="light">
          2019 청년참여플랫폼 사업은 여성가족부와 진저티프로젝트가 추진하며 빠띠가 협력합니다.
        </p>
      </div>
      <div class="helpers">
        <a href="http://www.mogef.go.kr/" target="_blank" class="term-link-logo"><img src="${pageContext.request.contextPath}/images/wf-logo.png" alt="여성가족부" style="width:146px"></a>
        <a href="http://gingertproject.co.kr/" target="_blank" class="term-link-logo"><img src="${pageContext.request.contextPath}/images/ginger-logo.png" alt="진저티프로젝트" style="width:71px"></a>
        <a href="http://parti.coop/" target="_blank" class="term-link-logo"><img src="${pageContext.request.contextPath}/images/parti-logo.png" alt="빠띠" style="width:57px"></a>
      </div>

      <h4 class="demo-detail-title demo-detail-title-border-top">버터나이프크루</h4>
      <img src="${pageContext.request.contextPath}/images/butter.png" class="box-butter">
      <div class="terms-wrapper">
        <p class="lead">버터는 일상의 기쁨이자 사회적 리소스를 상징합니다</p>
        <p class="blockquote">
          "행복은 빠다야!"
          <span class="byline">- 도서 《여자 둘이 살고 있습니다》 중</span>
        </p>

        <p class="comments">
          여기서 버터(빠다)는 갓 구운 빵에 덩어리째 발라먹는 버터처럼, 사소하고 일상적이지만 확실한 행복을 상징합니다.
          매일 밤 요가로 스트레스를 풀고 평안을 찾는다면 당신의 버터는 요가이고, 넷플릭스 두 편과 맥주 한잔의 꿀조합을 하루 중 가장 많이 기다린다면 그것이 당신의 버터입니다.
          이 플랫폼이 우리 각자의 명확한 행복, 우리 각자의 버터를 지키고 나눌 수 있는 곳이 되기를 희망하며 버터라는 개념을 제안했습니다.
        </p>
      </div>
      <div class="terms-wrapper">
        <p class="lead">나이프는 기쁨을 나누어주는 도구를 뜻합니다 </p>
        <p class="comments">
          참여를 통해 자신의 삶에 버터 한 덩어리 더 얹어 행복한 오늘을 맞이할 수 있다는 의미입니다.
        </p>
      </div>
      <h4 class="demo-detail-title demo-detail-title-border-top">버터나이프크루와 함께하는 청년</h4>
      <div class="interview-box-contianer">
        <c:forEach var="interview" items="${interviews}">
          <div class="col-sm-6 interview-wrapper">
            <div class="interview">
              <div class="name">${interview["name"]}</div>
              <div class="org">${interview["org"]}</div>
              <p class="body">${interview["body"]}</p>
              <img src="${pageContext.request.contextPath}/images/butter.png" class="butter">
            </div>
          </div>
        </c:forEach>
      </div>
    </div>
  </div>
<%@ include file="../shared/footer.jsp" %>
</body>
</html>
