<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>${groupText} 관리 - 상세 - Democracy</title>
  <%@ include file="../shared/head.jsp" %>
</head>
<body class="hold-transition skin-black-light fixed sidebar-mini admin">

<div class="wrapper">
  <%@ include file="../shared/header.jsp" %>

  <div class="content-wrapper">
    <section class="content-header">
      <h1>${groupText} 관리 - 상세 <a href="<c:url value="/admin/issue/${groupPrefix}debate-edit.do?id=${debate.id}"/>"
                                  class="btn btn-primary btn-sm pull-right">수정하기</a></h1>
    </section>

    <section class="content">
      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header with-border">
              <h3 class="box-title">${groupText}</h3>
            </div>
            <form class="form-horizontal">
              <div class="box-body">
                <div class="form-group">
                  <label class="col-sm-2 control-label">썸네일</label>
                  <div class="col-sm-4">
                    <img src="${debate.thumbnail}">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">분류</label>
                  <div class="col-sm-10"><p class="form-control-static">${debate.category.name}</p></div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">제목</label>
                  <div class="col-sm-10"><p class="form-control-static">${debate.title}</p></div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">한줄설명</label>
                  <div class="col-sm-10"><p class="form-control-static">${debate.excerpt}</p></div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">작성일</label>
                  <div class="col-sm-10"><p class="form-control-static">${debate.createdDate.toLocalDate()}</p></div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">작성자</label>
                  <div class="col-sm-10">
                    <p class="form-control-static">${debate.createdBy.name} / ${debate.createdBy.email}</p>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">조회수</label>
                  <div class="col-sm-10"><p class="form-control-static">${debate.stats.viewCount}</p></div>
                </div>
                <c:if test="${debate.opinionType.isDebate()}">
                  <div class="form-group">
                    <label class="col-sm-2 control-label">투표수</label>
                    <div class="col-sm-10">
                      <p class="form-control-static">
                        찬성 : ${debate.stats.yesCount}표(${debate.stats.yesPercent()}%) /
                        반대 : ${debate.stats.noCount}표(${debate.stats.noPercent()}%) /
                        기타 : ${debate.stats.etcCount}표(${debate.stats.etcPercent()}%)
                      </p>
                    </div>
                  </div>
                </c:if>
                <div class="form-group">
                  <label class="col-sm-2 control-label">댓글수</label>
                  <div class="col-sm-10"><p class="form-control-static">${debate.stats.opinionCount}</p></div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">기간</label>
                  <div class="col-sm-10"><p class="form-control-static">${debate.startDate} ~ ${debate.endDate}</p>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">공개여부</label>
                  <div class="col-sm-10"><p class="form-control-static">${debate.status.msg}</p></div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">첨부파일</label>
                  <div class="col-sm-10">
                    <c:forEach var="file" items="${debate.files}">
                      <p class="form-control-static">${file.name}</p>
                    </c:forEach>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">내용</label>
                  <div class="col-sm-10">
                    <div class="form-control-static">${debate.content}</div>
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label">연관제안</label>
                  <div class="col-sm-10">
                    <c:forEach var="relation" items="${debate.relations}" varStatus="status">
                      <c:set var="issue" value="${debate.issueMap[relation]}"/>
                      <c:if test="${issue.type eq 'P'}">
                        <p class="form-control-static">${issue.title}</p>
                      </c:if>
                    </c:forEach>
                  </div>
                </div>
                <c:if test="${issueGroup eq 'ORG'}">
                  <div class="form-group">
                    <label class="col-sm-2 control-label">연관토론</label>
                    <div class="col-sm-10">
                      <c:forEach var="relation" items="${debate.relations}" varStatus="status">
                        <c:set var="issue" value="${debate.issueMap[relation]}"/>
                        <c:if test="${issue.type eq 'D'}">
                          <p class="form-control-static">${issue.title}</p>
                        </c:if>
                      </c:forEach>
                    </div>
                  </div>
                </c:if>
                <c:if test="${debate.status eq 'OPEN'}">
                  <div class="form-group">
                    <label class="col-sm-2 control-label">히스토리 작성</label>
                    <div class="col-sm-10">
                      <a href="<c:url value="/debate-history.do?id=${debate.id}#middle-nav-tab"/>" target="_blank"
                         class="btn btn-default btn-sm">작성하러 가기</a>
                    </div>
                  </div>
                </c:if>
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
                <jsp:param name="issueId" value="${debate.id}"/>
                <jsp:param name="opinionType" value="${debate.opinionType}"/>
              </jsp:include>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
  <%@ include file="../shared/footer.jsp" %>
</div>
</body>
</html>
