<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <title>정책살롱 - 버터나이프크루</title>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="home body-salon body-policy">
    <%@ include file="../shared/header.jsp" %>

    <div class="container">
      <div class="top-row">
        <h3 class="top-row__title">1기 정책살롱</h3>
      </div>

      <hr class="thick-hr" />

      <h4>버터나이프크루 정책살롱</h4>
      <article>
        버터나이프크루 정책살롱은 정책추진단 103인이 정책을 제안하기 위해 함께
        경험한 과정과 결과 모두에 집중합니다. 정책추진단은 성평등한 관점에서
        개인이 읽은 세상의 변화를 함께 이야기하고, 변화에 맞는 사회를 상상하며,
        상상한 사회를 만들기 위해 함께 협력하고 기여하며, 정책을 만들어갑니다.
        정책살롱은 청년의 삶과 거리감이 느껴지는 정책이 아닌 달라진 삶이 반영된
        정책을 상상하며, 함께 한 상상이 과정에 잘 담길 수 있도록 오프라인과
        온라인을 통하여 진행했습니다.
        <br />
        <br />
        정책추진단이라는 이름으로 모인 청년 개인에게 충분히 이야기할 기회를
        주고, 서로에게 공감하며, 평등함에서 오는 안전함을 느낄 수 있도록
        정책살롱을 조성했습니다. 함께 모인 우리는 정책살롱을 통하여 목적을 갖고
        대화와 토론을 나누었으며, 다른 사람들과 연대하여 정책 제안을 하는 경험을
        통하여 성취감을 느낄 수 있었습니다. 단순히 오프라인을 통한 과정이 아닌
        온라인과 상호작용하며 서로의 의견에 적극적으로 공감했습니다.
        오프라인에서 나눈 대화의 맥락에 맞게 온라인에서 개인의 아이디어를
        제안하고, 버터보드(정책제안)를 공동으로 작업하며 전국에서 모인
        정책추진단이 지역과 거리를 넘어서 의견을 소통했습니다. 이러한 과정을
        통하여 건강 ・ 성평등 교육 ・ 미디어 ・ 일 ・ 지역 ・ 주거 ・ 가족의
        주제로 15개 팀이 청년의 달라진 삶을 반영하는 정책을 제안했습니다.
      </article>
      <section>
        <div class="youtube">
          <iframe
            width="560"
            height="315"
            src="https://www.youtube.com/embed/athlPwsuWAw"
            frameborder="0"
            allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen
          ></iframe>
        </div>
        <div class="youtube">
          <iframe
            width="560"
            height="315"
            src="https://www.youtube.com/embed/f6MlZxDP04Y"
            frameborder="0"
            allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen
          ></iframe>
        </div>
      </section>
    </div>

    <section class="projects">
      <div class="container policy-article-div">
        <h4 id="정책살롱타임라인">정책살롱 타임라인</h4>
        <div class="image-container">
          <img
            src="<c:url value='/images/policy2.png' />"
            alt="정책살롱 굽은선"
          />
        </div>
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
    </section>
    <%@ include file="../shared/footer.jsp" %>
  </body>
</html>
