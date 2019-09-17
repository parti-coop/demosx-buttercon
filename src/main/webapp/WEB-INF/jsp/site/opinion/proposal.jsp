<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="discussion-comment-form" id="discussion-comment-form">
  <c:if test="${param.closed eq true}">
    <h4><b>토론 기간동안 댓글 작성이 가능합니다.</b> (${debate.startDate} ~ ${debate.endDate})</h4>
  </c:if>
  <c:if test="${param.closed ne true}">
  <div class="demo-comment-form clearfix">
    <c:if test="${empty loginUser}">
      <div class="profile-circle profile-circle--comment-form" style="background-image: url(/images/noavatar.png)">
        <p class="alt-text">기본프로필</p>
      </div>
      <form>
        <textarea class="form-control demo-comment-textarea" rows="5" placeholder="로그인 후 댓글을 달 수 있습니다."
                  disabled></textarea>
        <div class="comment-action-group row">
          <div class="comment-count col-xs-6"><p class="comment-count-text">0/1000자</p></div>
          <div class="comment-submit text-right col-xs-6">
            <button type="button" class="btn btn-default btn-responsive-sm-md-md pull-right show-login-modal">등록
            </button>
          </div>
        </div>
      </form>
    </c:if>
    <c:if test="${not empty loginUser}">
      <div class="profile-circle profile-circle--comment-form" style="background-image: url(${loginUser.viewPhoto()})">
        <p class="alt-text">${loginUser.name}프로필</p>
      </div>
      <form id="form-opinion">
        <input type="hidden" name="issueId" value="${param.id}">
        <input type="hidden" name="vote" value="ETC">
        <div class="form-group">
          <textarea class="form-control demo-comment-textarea" rows="5" name="content"
                    data-parsley-required="true" data-parsley-maxlength="1000"></textarea>
        </div>
        <div class="comment-action-group row">
          <div class="comment-count col-xs-6"><p class="comment-count-text"><span id="opinion-length">0</span>/1000자</p>
          </div>
          <div class="comment-submit text-right col-xs-6">
            <button type="submit" class="btn btn-default btn-responsive-sm-md-md pull-right">등록
            </button>
          </div>
        </div>
      </form>
    </c:if>
  </div>
  </c:if>
</div>

<c:if test="${not empty loginUser}">
  <div class="modal fade" id="modalEditOpinion" tabindex="-1" role="dialog" aria-labelledby="의견 수정하기">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-body">
          <form class="demo-form" id="form-edit-opinion">
            <input type="hidden" name="opinionId" value="">
            <div class="form-input-container form-input-container--history">
              <div class="form-group form-group--demo">
                <label class="demo-form-label" for="inputContent">수정</label>
                <textarea class="form-control" name="content" id="inputContent" rows="8"
                          data-parsley-required="true" data-parsley-maxlength="1000"></textarea>
              </div>
            </div>
            <div class="form-action text-right">
              <button class="btn cancel-btn btn-lg" data-dismiss="modal" aria-label="Close" role="button">취소
              </button>
              <button type="submit" class="btn btn-primary btn-lg">등록</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</c:if>

<c:if test="${not empty loginUser}">
  <div class="modal fade" id="modalNewChildOpinion" tabindex="-1" role="dialog" aria-labelledby="의견 등록">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-body">
          <form class="demo-form" id="form-new-child-opinion">
            <input type="hidden" name="parentOpinionId" value="">
            <div class="form-input-container form-input-container--history">
              <div class="form-group form-group--demo">
                <label class="demo-form-label" for="inputContent">의견 등록</label>
                <textarea class="form-control" name="content" id="inputContent" rows="8"
                          data-parsley-required="true" data-parsley-maxlength="1000"></textarea>
              </div>
            </div>
            <div class="form-action text-right">
              <button class="btn cancel-btn btn-lg" data-dismiss="modal" aria-label="Close" role="button">취소
              </button>
              <button type="submit" class="btn btn-primary btn-lg">등록</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</c:if>

<div class="demo-comments-container js-demo-comments-container collapse">
  <div class="demo-comments-top">
    <div class="demo-comments-top__tabs demo-comments-top__tabs--discuss clearfix">
      <div class="demo-comments-lead pull-left">
        댓글
      </div>
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
  <ul class="demo-comments" id="opinion-list"></ul>
  <div class="show-more-container text-center">
    <button class="btn btn-default btn-outline btn-responsive-sm-md-md" type="button" id="opinion-more">더 보기<i class="xi-angle-down-min"></i>
    </button>
  </div>
</div>

<!-- template -->
<script id="template-opinion" type="text/x-handlebars-template">
  {{#*inline "partialCommentLine"}}
    <li class="comment-li">
      <div class="comment-content">
        <div class="comment-info clearfix">
          <div class="comment-date-wrapper">
            <p class="comment-name">{{ opinion.createdBy.name }}</p>
            <p class="comment-time">{{ opinion.contextAssigns.createdDateShort }}</p>
          </div>
        </div>
        <p class="comment-content-text js-comment-content-text-{{ opinion.id }}">{{{ opinion.contextAssigns.contentBr }}}</p>
        {{#if @root.isSignedIn}}
          <div class="clearfix">
            {{#if opinion.contextAssigns.canHaveChildOpinions}}
            <button type="button"
              class="btn btn-default btn-responsive-xs-sm-sm btn-no-border js-new-child-opinion-btn"
              data-id="{{ opinion.id }}">댓글 달기</button>
            {{/if}}
            <div class="comment-likes-count">
              <button class="btn btn-responsive-xs-sm-sm js-opinion-thumbs-up-btn {{#if opinion.liked}}active btn-primary btn-outline{{else}}btn-no-border btn-default{{/if}}" data-id="{{ opinion.id }}">
                <i class="xi-thumbs-up"></i> 공감 <strong>{{ opinion.likeCount }}</strong>개
              </button>
            </div>
            {{#if opinion.contextAssigns.isOwner}}
            <button type="button"
              class="btn btn-default btn-responsive-xs-sm-sm btn-no-border js-edit-opinion-btn js-edit-opinion-btn-{{ opinion.id }}"
              data-id="{{ opinion.id }}" data-content="{{ opinion.content }}">수정</button>
            <button type="button"
              class="btn btn-default btn-responsive-xs-sm-sm btn-no-border delete-opinion-btn"
              data-id="{{ opinion.id }}">삭제</button>
            {{/if}}
          </div>
        {{else}}
          <div class="clearfix">
            {{#if opinion.contextAssigns.canHaveChildOpinions}}
            <button type="button"
              class="btn btn-default btn-responsive-xs-sm-sm btn-no-border show-login-modal"
              data-id="{{ opinion.id }}">댓글 달기</button>
            {{/if}}
            <div class="comment-likes-count">
              <button class="btn btn-responsive-xs-sm-sm show-login-modal btn-no-border btn-default">
                <i class="xi-thumbs-up"></i> 공감 <strong>{{ opinion.likeCount }}</strong>개
              </button>
            </div>
          </div>
        {{/if}}
      </div>
    {{/inline}}

    <!-- 부모 댓글 --->
    {{> partialCommentLine }}

    {{#if opinion.contextAssigns.canHaveChildOpinions}}
      <!-- 자식 댓글 --->
      <ul class='demo-child-comments js-child-opinions-list-{{ opinion.id }} {{#unless opinion.contextAssigns.hasChildOpinions}}collapse{{/unless}}'>
        {{#each opinion.childOpinions}}
          {{> partialCommentLine opinion=this }}
        {{/each}}
      </ul>
    {{/if}}
  </li>
</script>

<script>
$(function () {
  <c:if test="${not empty loginUser}">
    // 의견 등록
    (function() {
      var $opinionLength = $('#opinion-length');
      $('textarea[name=content]').keyup(function () {
        $opinionLength.text($(this).val().length);
      });
    })();

    (function() {
      var $formOpinion = $('#form-opinion');
      $formOpinion.parsley(parsleyConfig);
      $formOpinion.on('submit', function (event) {
        event.preventDefault();

        var data = $formOpinion.serializeObject();
        $.ajax({
          headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
          url: '/ajax/mypage/opinions',
          type: 'POST',
          contentType: 'application/json',
          dataType: 'json',
          data: JSON.stringify(data),
          success: function (data) {
            alert(data.msg);
            $('#latest-sort-btn').trigger('click');
            $formOpinion[0].reset();
            $formOpinion.parsley().reset();
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
    })();

    $(document).on('click', '.delete-opinion-btn', function () {
      if (!window.confirm('삭제할까요?')) return;

      var id = $(this).data('id');

      var that = this;
      $.ajax({
        headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
        url: '/ajax/mypage/opinions/' + id,
        type: 'DELETE',
        contentType: 'application/json',
        dataType: 'json',
        success: function (data) {
          alert(data.msg);
          $(that).parents('.comment-li').remove();
        },
        error: function (error) {
          if (error.status === 400) {
            if (error.responseJSON.fieldErrors) {
              var msg = error.responseJSON.fieldErrors.map(function (item) {
                return item.fieldError;
              }).join('/n');
              alert(msg);
            } else alert(error.responseJSON.msg);
          } else if (error.status === 401) {
            alert('로그인이 필요합니다.');
            window.location.href = '/login.do';
          } else if (error.status === 403) {
            alert('삭제할 수 없습니다.');
          }
        }
      });
    });

    // 의견 수정
    (function() {
      var $formOpinion = $('#form-opinion');
      var $opinionContent = null;
      var $modalEditOpinion = $('#modalEditOpinion');
      $(document).on('click', '.js-edit-opinion-btn', function() {
        $formOpinion[0].reset();
        $formOpinion.parsley().reset();
        $opinionContent = $(this).parents('.comment-li');
        $('input[name=opinionId]', $modalEditOpinion).val($(this).data('id'));
        $('textarea[name=content]', $modalEditOpinion).val($(this).data('content'));
        $modalEditOpinion.modal('show');
      });
      var $formEditOpinion = $('#form-edit-opinion');
      $formEditOpinion.parsley(parsleyConfig);
      $formEditOpinion.on('submit', function (event) {
        event.preventDefault();
        var data = $formEditOpinion.serializeObject();
        $.ajax({
          headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
          url: '/ajax/mypage/opinions/' + data.opinionId,
          type: 'PUT',
          contentType: 'application/json',
          dataType: 'json',
          data: JSON.stringify(data),
          success: function (result) {
            alert(result.msg);
            if(result.contents && result.contents.opinion) {
              var opinion = result.contents.opinion;
              $('.js-comment-content-text-' + opinion.id, $opinionContent).html(opinion.content.replace(/\r\n|\r|\n|\n\r/g, '<br>'));
              $('.js-edit-opinion-btn-' + opinion.id, $opinionContent).data('content', opinion.content);
              $formEditOpinion[0].reset();
              $formEditOpinion.parsley().reset();
              $modalEditOpinion.modal('hide');
            }
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
    })();

    // 의견 대댓글
    (function() {
      var $formOpinion = $('#form-opinion');
      var $opinionContent = null;
      var $modalNewChildOpinion = $('#modalNewChildOpinion');
      $(document).on('click', '.js-new-child-opinion-btn', function() {
        $formOpinion[0].reset();
        $formOpinion.parsley().reset();
        $opinionContent = $(this).parents('.comment-li');
        $('input[name=parentOpinionId]', $modalNewChildOpinion).val($(this).data('id'));
        $modalNewChildOpinion.modal('show');
      });
      var $formNewChildOpinion = $('#form-new-child-opinion');
      $formNewChildOpinion.parsley(parsleyConfig);
      $formNewChildOpinion.on('submit', function (event) {
        event.preventDefault();
        var data = $formNewChildOpinion.serializeObject();
        $.ajax({
          headers: { 'X-CSRF-TOKEN': '${_csrf.token}' },
          url: '/ajax/mypage/opinions/' + data.parentOpinionId + '/child-opinion',
          type: 'POST',
          contentType: 'application/json',
          dataType: 'json',
          data: JSON.stringify(data),
          success: function (result) {
            alert(result.msg);
            if(result.contents && result.contents.opinion) {
              var opinion = result.contents.opinion;
              var content = $$makeOpinionString(opinion);
              $('.js-child-opinions-list-' + opinion.parentOpinionId, $opinionContent).prepend(content);
              $('.js-child-opinions-list-' + opinion.parentOpinionId, $opinionContent).show();
              $formNewChildOpinion[0].reset();
              $formNewChildOpinion.parsley().reset();
              $modalNewChildOpinion.modal('hide');
            }
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
    })();


    // 의견 공감
    $(document).on('click', '.js-opinion-thumbs-up-btn', function () {
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
            that.removeClass('btn-primary');
            that.removeClass('btn-outline');
            that.addClass('btn-default');
            that.addClass('btn-no-border ');
            if (count !== 0) $('strong', that).text(count - 1);
          }
          else {
            that.addClass('active');
            that.addClass('btn-primary');
            that.addClass('btn-outline');
            that.removeClass('btn-default');
            that.removeClass('btn-no-border ');
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
  </c:if>

  (function() {
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
            var content = $$makeOpinionString(data.content[i]);
            $opinionList.append(content);
          }
          if(data.content.length > 0) $('.js-demo-comments-container').show();
          $opinionList.css('height', 'auto');
          if (data.last) $opinionMore.addClass('hidden');
          else $opinionMore.removeClass('hidden');
        },
        error: function (error) {
          console.log(error);
        }
      });
    }
    getOpinion();
  })();

  <c:if test="${not empty loginUser}">
    var $$userId = ${loginUser.id};
  </c:if>
  <c:if test="${empty loginUser}">
    var $$userId = null;
  </c:if>

  var $$templateOpinion = Handlebars.compile($("#template-opinion").html());
  function $$makeOpinionString(opinion) {
    var contextAssignedOpinion = $$contextAssignOpinion($.extend(true, {}, opinion), $$userId);
    return $$templateOpinion({
      isSignedIn: (!!$$userId),
      opinion: contextAssignedOpinion,
    });
  }

  function $$contextAssignOpinion(opinion) {
    if(opinion.childOpinions) {
      $.each(opinion.childOpinions, function(index, childOpinion) {
        $$contextAssignOpinion(childOpinion);
      });
    }
    opinion['contextAssigns'] = {
      isOwner: (opinion.createdBy.id === $$userId),
      photo: opinion.createdBy.photo || '/images/noavatar.png',
      contentBr: opinion.content.replace(/\r\n|\r|\n|\n\r/g, '<br>'),
      createdDateShort: opinion.createdDate.substring(0, opinion.createdDate.indexOf(' ')),
      canHaveChildOpinions: (!opinion.parentOpinionId),
      hasChildOpinions: (!opinion.parentOpinionId && opinion.childOpinions && opinion.childOpinions.length > 0),
    }
    return opinion;
  }
});
</script>