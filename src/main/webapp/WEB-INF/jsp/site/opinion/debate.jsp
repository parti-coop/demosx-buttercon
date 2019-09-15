<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${not empty loginUser}">
  <div class="modal fade" id="modalEditOpinion" tabindex="-1" role="dialog" aria-labelledby="의견 수정하기">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-body">
          <form class="demo-form" id="form-edit-opinion">
            <input type="hidden" name="issueId" value="${param.id}">
            <input type="hidden" name="vote" value="">
            <input type="hidden" name="opinionId" value="">
            <div class="form-input-container form-input-container--history">
              <div class="form-group">
                <label class="demo-form-label debate-opinion-text hidden" id="yes-opinion" for="inputContent">의견 -
                  찬성합니다.</label>
                <label class="demo-form-label debate-opinion-text hidden" id="no-opinion" for="inputContent">의견 -
                  반대합니다.</label>
                <label class="demo-form-label debate-opinion-text hidden" id="etc-opinion" for="inputContent">의견 -
                  기타의견입니다.</label>
                <textarea class="form-control" name="content" id="inputContent" rows="8"
                          data-parsley-required="true" data-parsley-maxlength="1000"></textarea>
                <p><span id="opinion-length">0</span>/1000자</p>
              </div>
            </div>
            <div class="form-action text-right">
              <div class="btn-group clearfix">
                <button class="btn demo-submit-btn cancel-btn" data-dismiss="modal" aria-label="Close" role="button">취소
                </button>
                <button type="submit" class="demo-submit-btn demo-submit-btn--submit">저장하기</button>
              </div>
            </div>

          </form>
        </div>
      </div>
    </div>
  </div>
</c:if>

<div class="demo-comments-container">
  <div class="demo-comments-top">
    <div class="clearfix">
      <div class="demo-comments-top__tabs demo-comments-top__tabs--discuss">
        <ul class="comment-sorting-ul clearfix">
          <li class="comment-sorting-li active">
            <a class="sorting-link opinion-sort" id="latest-sort-btn" data-sort="createdDate,desc" href="#">최신순</a>
          </li>
          <li class="comment-sorting-li">
            <a class="sorting-link opinion-sort" data-sort="createdDate,asc" href="#">과거순</a>
          </li>
          <li class="comment-sorting-li">
            <a class="sorting-link opinion-sort" data-sort="likeCount,desc" href="#">공감순</a>
          </li>
        </ul>
      </div>
    </div>
  </div>
  <ul class="demo-comments" id="opinion-list"></ul>
  <div class="comment-end-line"></div>
  <div class="show-more-container text-center">
    <button class="white-btn d-btn btn-more" type="button" id="opinion-more">더보기<i class="xi-angle-down-min"></i>
    </button>
  </div>
</div>

<script>
  <c:if test="${empty loginUser}">
  $(function () {
    $(document).on('click', '.show-opinion-modal', function () {
      <c:if test="${param.closed eq true}">
      alert('투표 기간동안 작성 가능합니다.');
      </c:if>
      <c:if test="${param.closed ne true}">
      $('#modal-login').modal('show');
      </c:if>
    });
  });
  </c:if>
  <c:if test="${not empty loginUser}">
  $(function () {
    var $formEditOpinion = $('#form-edit-opinion');
    $formEditOpinion.parsley(parsleyConfig);

    var $opinionLength = $('#opinion-length');
    $('textarea[name=content]', $formEditOpinion).keyup(function () {
      $opinionLength.text($(this).val().length);
    });

    var $modalEditOpinion = $('#modalEditOpinion');
    $(document).on('click', '.show-opinion-modal', function () {
      <c:if test="${param.closed eq true}">
      alert('투표 기간동안 작성 가능합니다.');
      </c:if>
      <c:if test="${param.closed ne true}">
      var vote = $(this).data('vote');
      var id = $(this).data('id');
      $formEditOpinion[0].reset();
      $formEditOpinion.parsley().reset();
      $('.debate-opinion-text').addClass('hidden');
      $('#' + vote.toLowerCase() + '-opinion').removeClass('hidden');
      $('input[name=vote]', $formEditOpinion).val(vote);
      if(id) {
        var content = $(this).data('content');
        console.log(content.length);
        $('input[name=opinionId]', $formEditOpinion).val(id);
        $('textarea[name=content]', $formEditOpinion).val(content);
        $opinionLength.text(content.toString().length);
      } else {
        $('input[name=opinionId]', $formEditOpinion).val('');
        $opinionLength.text('0');
      }
      $modalEditOpinion.modal('show');


      <%--$.ajax({
        headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
        url: '/ajax/mypage/opinions',
        type: 'GET',
        contentType: 'application/json',
        dataType: 'json',
        data: {
          issueId: ${debate.id}
        },
        success: function (data) {
          if (data.id) {
            vote = data.vote;
            $('#has-opinion').removeClass('hidden');
            $('textarea[name=content]', $formEditOpinion).val(data.content);
            $opinionLength.text(data.content.length);
          }
          $('#' + vote.toLowerCase() + '-opinion').removeClass('hidden');
          $('input[name=opinionId]', $formEditOpinion).val(data.id);
          $('input[name=vote]', $formEditOpinion).val(vote);
          $modalEditOpinion.modal('show');
        },
        error: function (error) {
          if (error.status === 400) {
            if (error.responseJSON.fieldErrors) {
              var msg = error.responseJSON.fieldErrors.map(function (item) {
                return item.fieldError;
              }).join('/n');
              alert(msg);
            } else alert(error.responseJSON.msg);
          } else if (error.status === 403 || error.status === 401) {
            alert('로그인이 필요합니다.');
            window.location.href = '/login.do';
          }
        }
      });--%>
      </c:if>
    });

    // 의견 등록/수정
    $formEditOpinion.on('submit', function (event) {
      event.preventDefault();
      var data = $formEditOpinion.serializeObject();
      var isNew = !data.opinionId;
      $.ajax({
        headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
        url: '/ajax/mypage/opinions' + (isNew ? '' : ('/' + data.opinionId)),
        type: isNew ? 'POST' : 'PUT',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify(data),
        success: function (result) {
          alert(result.msg);
          if (isNew) {
            //$('#latest-sort-btn').trigger('click');
            window.location.reload();
          } else {
            $('.comment-content-text[data-id=' + data.opinionId + ']').html(data.content.replace(/\r\n|\r|\n|\n\r/g, '<br>'));
          }
          $modalEditOpinion.modal('hide');
        },
        error: function (error) {
          if (error.status === 400) {
            if (error.responseJSON.fieldErrors) {
              var msg = error.responseJSON.fieldErrors.map(function (item) {
                return item.fieldError;
              }).join('/n');
              alert(msg);
            } else alert(error.responseJSON.msg);
          } else if (error.status === 403 || error.status === 401) {
            alert('로그인이 필요합니다.');
            window.location.href = '/login.do';
          }
        }
      });
    });

    // 의견 공감
    $(document).on('click', '.opinion-thumbs-up-btn', function () {
      var hasLike = $(this).hasClass('active');
      var id = $(this).data('id');
      var that = $(this);
      $.ajax({
        headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
        url: '/ajax/mypage/opinions/' + id + '/' + (hasLike ? 'deselectLike' : 'selectLike'),
        type: 'PUT',
        contentType: 'application/json',
        dataType: 'json',
        success: function (data) {
          alert(data.msg);
          var count = +$('strong', that).text();
          if (hasLike) {
            that.removeClass('active');
            if (count !== 0) $('strong', that).text(count - 1);
          }
          else {
            that.addClass('active');
            $('strong', that).text(count + 1);
          }
        },
        error: function (error) {
          if (error.status === 400) {
            if (hasLike) that.removeClass('active');
            else that.addClass('active');
            if (error.responseJSON.fieldErrors) {
              var msg = error.responseJSON.fieldErrors.map(function (item) {
                return item.fieldError;
              }).join('/n');
              alert(msg);
            } else alert(error.responseJSON.msg);
          } else if (error.status === 403 || error.status === 401) {
            alert('로그인이 필요합니다.');
            window.location.href = '/login.do';
          }
        }
      });
    });
  });
  </c:if>
  $(function () {
      <c:if test="${not empty loginUser}">var userId = ${loginUser.id};
    </c:if>
      <c:if test="${empty loginUser}">var userId = null;
    </c:if>
    var page = 1;
    var sort = 'createdDate,desc';
    var $opinionList = $('#opinion-list');
    var $opinionMore = $('#opinion-more');
    var $opinionCount = $('#opinion-count');
    $('.opinion-sort').click(function (event) {
      event.preventDefault();
      var selectedSort = $(this).data('sort');

      $opinionList.css('height', $opinionList.height());
      $opinionList.text('');
      $('.comment-sorting-li').removeClass('active');
      $(this).parent('.comment-sorting-li').addClass('active');

      page = 1;
      sort = selectedSort;
      getOpinion();
    });

    $opinionMore.click(function () {
      page++;
      getOpinion();
    });

    function getOpinion() {
      $.ajax({
        headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
        url: '/ajax/opinions',
        contentType: 'application/json',
        data: {
          issueId: ${param.id},
          page: page,
          'sort[]': sort
        },
        success: function (data) {
          $opinionCount.text(data.totalElements);
          for (var i = 0; i < data.content.length; i++) {
            var content = makeOpinionString(data.content[i]);
            $opinionList.append(content);
          }
          $opinionList.css('height', 'auto');
          if (data.last) $opinionMore.addClass('hidden');
          else $opinionMore.removeClass('hidden');
        },
        error: function (error) {
          console.log(error);
        }
      });
    }

    var opinionText = {
      'YES': '찬성',
      'NO': '반대',
      'ETC': '기타'
    };
    var opinionClass = {
      'YES': 'agree',
      'NO': 'reject',
      'ETC': 'etc'
    };

    function makeOpinionString(opinion) {
      var photo = opinion.createdBy.photo || '/images/noavatar.png';

      var ownerMenu = '';
      if (opinion.createdBy.id === userId) {
        ownerMenu = '        <div class="clearfix">' +
          '          <div class="pull-right">' +
          '            <button type="button" class="btn btn-default btn-sm show-opinion-modal" data-id="' + opinion.id + '" data-vote="' + opinion.vote + '" data-content="' + opinion.content + '">수정하기</button>' +
          '          </div>' +
          '        </div>';
      }

      return '<li class="comment-li">' +
        '      <div class="profile-circle profile-circle--comment" style="background-image: url(' + photo + ')">' +
        '        <p class="alt-text">' + opinion.createdBy.name + '사진</p>' +
        '      </div>' +
        '      <div class="comment-content">' +
        '        <div class="comment-info clearfix">' +
        '          <div class="comment-date-wrapper">' +
        '            <p class="comment-name">' + opinion.createdBy.name + '</p>' +
        '            <p class="comment-time"><i class="xi-time"></i> ' + opinion.createdDate.substring(0, opinion.createdDate.indexOf(' ')) + '</p>' +
        '          </div>' +
        '          <div class="comment-likes-count">' +
        '            <button class="opinion-thumbs-up-btn' + (opinion.liked ? ' active' : '') + '" data-id="' + opinion.id + '">' +
        '              <i class="xi-thumbs-up"></i> 공감 <strong>' + opinion.likeCount + '</strong>개' +
        '            </button>' +
        '          </div>' +
        '        </div>' +
        '        <div class="comment-vote-result">' +
        '          <div class="comment-text-wrapper">' +
        '            <p class="comment-content-text" data-id="' + opinion.id + '">' + opinion.content.replace(/\r\n|\r|\n|\n\r/g, '<br>') + '</p>' +
        '          </div>' +
        '          <div class="comment-status-wrapper">' +
        '            <p class="status-btn status-btn--' + opinionClass[opinion.vote] + '">' + opinionText[opinion.vote] + '</p>' +
        '          </div>' +
        '        </div>' +
        ownerMenu +
        '      </div>' +
        '    </li>';
    }

    getOpinion();
  });
</script>