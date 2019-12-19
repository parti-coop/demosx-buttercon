<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<head>
  <title>버터나이프크루</title>
  <%@ include file="./shared/head.jsp" %>
</head>
<body class="home header-no-margin body-home">
  <%@ include file="./shared/header.jsp" %>
  <section class="section-main-key-visual">
    <div class="container">
      <div class="key-title">
        나의 삶은 달라지고 있고,
        <br />
        우리가 변화의 흐름을 만든다
      </div>
      <div class="key-subtitle">
        버터나이프크루는 우리의 달라진 삶에 필요한 정책을 제안하고(정책살롱)
        <br class="visible-md visible-lg" />
        우리의 달라진 삶을 반영하는 문화혁신사업(문화살롱)을 진행하는
        청년참여플랫폼입니다.
      </div>
      <div class="key-visual">
        <img src="<c:url value='/images/key-visual-butter.png'/>" />
      </div>
      <a
        href="<c:url value='/intro.do'/>"
        class="btn demo-btn demo-btn--primary key-btn"
        >자세히보기</a
      >
    </div>
  </section>
  <section class="section-banner">
    <div class="container">
      <div class="key-banner">
        <div class="key-banner-text">
          <span class="text-nowrap">
            2019 버터나이프크루의 여정을 담은 온라인 전시
          </span>
        </div>
        <div class="key-banner-btn-container">
          2020년 2월 오픈예정
        </div>
      </div>
    </div>
  </section>
  <section class="section-proposals">
    <div class="container">
      <div class="main-card-list">
        <div class="main-card-list-lead">
          <div class="main-card-list-lead-title-container">
            <div class="main-card-list-lead-title">정책살롱</div>
            <div class="main-card-list-lead-subtitle">
              청년의 달라진 삶에 필요한 정책제안
            </div>
          </div>
          <a
            href="<c:url value='/policy.do'/>"
            class="main-card-list-lead-button"
          >
            정책살롱 자세히보기 <i class="xi-angle-right"></i>
          </a>
        </div>
      </div>

      <article class="policy-article">
        <img
          src="<c:url value='/images/top-policy.jpg'/>"
          alt="정책살롱 사진"
          class="policy-image"
        />
        <div class="policy-article-div">
          <p class="desc">
            버터나이프크루 정책살롱은 청년의 달라진 삶을 성평등한 관점으로
            정책에 반영하기 위해 개인이 읽은 세상의 변화를 함께 이야기하고,
            변화에 맞는 사회를 상상하며 토론하고, 정책제안을 하기 위해 진행한
            오프라인 모임과 온라인 활동입니다.
          </p>
          <h3>2019 버터나이프크루 정책살롱</h3>
          <div class="flex-row">
            <div class="yellow-line">
              <div class="flex-row start">
                <div class="line first"><i class="first"></i></div>
                <div class="bold">시즌 1 "경험에서 프로젝트로"</div>
              </div>
              <div class="flex-row start">
                <div class="line"><i class=""></i></div>
                <div class="flex-column">
                  <div class="bold">8월 아이디어 살롱</div>
                  <div class="sub">나와 우리의 경험</div>
                </div>
              </div>
              <div class="flex-row start">
                <div class="line"><i class=""></i></div>
                <div class="flex-column">
                  <div class="bold">9월 아이디어 살롱</div>
                  <div class="sub">나와 우리의 주제</div>
                </div>
              </div>
              <div class="flex-row start">
                <div class="line last"><i class=""></i></div>
                <div class="flex-column">
                  <div class="bold">10월 해커톤 살롱</div>
                  <div class="sub">나와 우리의 프로젝트</div>
                </div>
              </div>
            </div>
            <div class="yellow-line">
              <div class="flex-row start">
                <div class="line first"><i class="first"></i></div>
                <div class="bold">시즌 2 "프로젝트에서 제안서로"</div>
              </div>
              <div class="flex-row start">
                <div class="line"><i class=""></i></div>
                <div class="flex-column">
                  <div class="bold">10월 공동작업 살롱</div>
                  <div class="sub">프로젝트 리서치 및 피드백</div>
                </div>
              </div>
              <div class="flex-row start">
                <div class="line"><i class=""></i></div>
                <div class="flex-column">
                  <div class="bold">11월 공동작업 살롱</div>
                  <div class="sub">프로젝트 제안서 및 피드백</div>
                </div>
              </div>
              <div class="flex-row start">
                <div class="line last"><i class=""></i></div>
                <div class="flex-column">
                  <div class="bold">12월 해커톤 살롱</div>
                  <div class="sub">최종 정리 및 공유</div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="button-mobile">
          <a href="<c:url value='/policy.do'/>">
            정책살롱 자세히보기
          </a>
        </div>
      </article>
      <article class="projects">
        <div class="main-card-list">
          <div class="main-card-list-lead">
            <div class="main-card-list-lead-title-container">
              <div class="main-card-list-lead-title">문화살롱</div>
              <div class="main-card-list-lead-subtitle">
                청년의 달라진 삶을 콘텐츠로 표현하는 문화혁신사업
              </div>
            </div>
            <a
              href="<c:url value='/content-list.do'/>"
              class="main-card-list-lead-button"
            >
              문화살롱 자세히보기 <i class="xi-angle-right"></i>
            </a>
          </div>
        </div>
        <div class="card-wrapper">
          <div class="row">
            <c:forEach var="item" items="${salons}">
              <c:set var="salon" value="${item}" scope="request" />
              <div class="col-sm-4 demo-card-wrapper">
                <jsp:include page="./salon/card.jsp" />
              </div>
            </c:forEach>
          </div>
        </div>
        <div class="card-wrapper-mobile">
          <div class="row">
            <c:forEach var="item" items="${salons}">
              <c:set var="salon" value="${item}" scope="request" />
              <div class="col-sm-4 demo-card-wrapper">
                <jsp:include page="./salon/card-mobile.jsp" />
              </div>
            </c:forEach>
          </div>
        </div>
        <div class="button-mobile">
          <a href="<c:url value='/content-list.do'/>">
            문화살롱 자세히보기
          </a>
        </div>
      </article>
    </div>
  </section>

  <%@ include file="./shared/footer.jsp" %>
</body>

<style></style>
