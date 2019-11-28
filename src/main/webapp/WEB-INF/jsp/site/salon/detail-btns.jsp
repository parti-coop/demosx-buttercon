<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="flex margin-top-40">
  <button
    class="${salon.liked eq true ? 'btn-outline active' : 'btn-trans'}${empty loginUser ? ' show-login-modal' : ''}"
    id="salon-like-btn"
  >
    <i class="fa fa-heart-o"></i> 공감 <strong>${salon.stats.likeCount}</strong>개
  </button>
  <button id="native-share" class="btn-trans mobile">
    <i class="fa fa-share-alt"></i>
    공유하기
  </button>
  <button class="dropdown btn-trans desktop">
    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
      <i class="fa fa-share-alt"></i>
      공유하기
    </a>
    <ul class="dropdown-menu dopdown-menu-auto">
      <li class="dropdown-item">
        <a href="#" class="js-share" data-mode="facebook">페이스북</a>
      </li>
      <li class="dropdown-item">
        <a href="#" class="js-share" data-mode="twitter">트위터</a>
      </li>
      <li class="dropdown-item">
        <a href="#" id="kakao-link-btn">카카오톡</a>
      </li>
      <li class="dropdown-item">
        <a class="detail-copy-url js-detail-copy-url">
          url복사
          <i class="xi-share-alt"></i>
        </a>
      </li>
    </ul>
  </button>
  <a href="<c:url value='/salon-list.do' />" alt="목록" class="link-to-list"
    >목록 <i class="fa fa-chevron-right"></i
  ></a>
</div>
