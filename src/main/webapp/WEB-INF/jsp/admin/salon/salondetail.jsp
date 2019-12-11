<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>문화살롱 관리 상세 - 버터나이프크루</title>
  <%@ include file="../shared/head.jsp" %>
</head>
<body class="hold-transition skin-black-light fixed sidebar-mini admin">

<div class="wrapper">
  <%@ include file="../shared/header.jsp" %>

  <div class="content-wrapper">
    <section class="content-header">
      <h1>문화살롱 관리 상세</h1>
    </section>

    <section class="content">
      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header with-border">
              <h3 class="box-title">문화살롱</h3>
            </div>
            <form class="form-horizontal">
              <div class="box-body">
                <div class="form-group">
                  <label class="col-sm-2 control-label">분류</label>
                  <div class="col-sm-2">
                    <c:if test="${loginUser.isManager()}">
                      <p class="form-control-static">${dto.category.name}</p>
                    </c:if>
                    <c:if test="${loginUser.isAdmin()}">
                      <select class="form-control input-sm" id="category-select">
                        <option value="">분류선택</option>
                        <c:forEach var="category" items="${categories}">
                          <option value="${category.name}" <c:if
                              test="${dto.category.name eq category.name}">selected</c:if>>${category.name}</option>
                        </c:forEach>
                      </select>
                    </c:if>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">제목</label>
                  <div class="col-sm-10"><p class="form-control-static">${dto.title}</p></div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">작성일</label>
                  <div class="col-sm-10"><p class="form-control-static">${dto.createdDate.toLocalDate()}</p></div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">작성자</label>
                  <div class="col-sm-10">
                    <p class="form-control-static">${dto.createdBy.name} / ${dto.createdBy.email}</p>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">조회수</label>
                  <div class="col-sm-10"><p class="form-control-static">${dto.stats.viewCount}</p></div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">공감수</label>
                  <div class="col-sm-10"><p class="form-control-static">${dto.stats.likeCount}</p></div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">댓글수</label>
                  <div class="col-sm-10"><p class="form-control-static">${dto.stats.opinionCount}</p></div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">공개여부</label>
                  <div class="col-sm-2">
                    <c:if test="${dto.status.isDelete()}">
                      <p class="form-control-static">${dto.status.msg}</p>
                    </c:if>
                    <c:if test="${dto.status ne 'DELETE'}">
                      <select class="form-control input-sm" id="status-select">
                        <option value="OPEN" <c:if test="${dto.status.isOpen()}">selected</c:if>>공개</option>
                        <option value="CLOSED" <c:if test="${dto.status.isClosed()}">selected</c:if>>비공개</option>
                      </select>
                    </c:if>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">내용</label>
                  <div class="col-sm-10"><p class="form-control-static">${dto.content}</p></div>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header with-border">
              <h3 class="box-title">댓글</h3>
            </div>
            <div class="box-body">
              <jsp:include page="../opinion/list.jsp">
                <jsp:param name="issueId" value="${dto.id}"/>
                <jsp:param name="opinionType" value="dto"/>
              </jsp:include>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
  <%@ include file="../shared/footer.jsp" %>
</div>
<script>
  $(function () {
    
    // 공개여부 수정
    var statusValue = '${dto.status}';
    var $statusSelect = $('#status-select');
    $statusSelect.change(function () {
      var status = $(this).val();
      if (!confirm((status === 'OPEN' ? '공개' : '비공개') + '로 변경할까요?')) {
        $(this).val(statusValue);
        return;
      }

      adminAjax({
        csrf: '${_csrf.token}',
        url: '/admin/ajax/issue/${dto.id}/' + status.toLowerCase(),
        type: 'PATCH',
        data: null,
        success: function () {
          statusValue = $statusSelect.val();
          window.location.reload();
        },
        error: function () {
          $statusSelect.val(statusValue);
        }
      });
    });

  });
</script>
</body>
</html>
