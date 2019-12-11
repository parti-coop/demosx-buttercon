<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <title>정책살롱 관리 - 버터나이프크루</title>
    <%@ include file="../shared/head.jsp" %>
  </head>
  <body class="hold-transition skin-black-light fixed sidebar-mini admin">
    <div class="wrapper">
      <%@ include file="../shared/header.jsp" %>

      <div class="content-wrapper">
        <section class="content-header">
          <h1>정책살롱 관리</h1>
        </section>

        <section class="content">
          <div class="row">
            <div class="col-xs-12">
              <div class="box">
                <div class="box-body">
                  <table
                    id="list"
                    class="table table-bordered table-striped"
                    width="100%"
                  >
                    <thead>
                      <tr>
                        <th>작성일</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>조회수</th>
                        <th>공감수</th>
                        <th>댓글수</th>
                        <th>공개여부</th>
                      </tr>
                    </thead>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </section>
      </div>
      <%@ include file="../shared/footer.jsp" %>
    </div>

    <script>
      $(function() {
        var sortColumn = ["createdDate"];
        var $category = $("select[name=category]");
        $category.change(function() {
          table.draw();
        });

        var table = $("#list")
          .on("preXhr.dt", function(e, settings, data) {
            data["page"] = data.start / data.length + 1;
            data["size"] = data.length;
            data["sort"] = [
              sortColumn[data["order"][0].column] + "," + data["order"][0].dir
            ];
            data["search"] = data["search"].value;

            delete data["draw"];
            delete data["columns"];
            delete data["order"];
            delete data["start"];
            delete data["length"];
          })
          .on("xhr.dt", function(e, settings, json, xhr) {
            json["recordsFiltered"] = json.totalElements;
            json["recordsTotal"] = json.totalElements;
            json["data"] = json.content;
          })
          .DataTable({
            lengthMenu: [10, 15, 20],
            language: {
              infoEmpty: "검색 결과가 없습니다.",
              zeroRecords: "검색 결과가 없습니다.",
              emptyTable: "테이블에 표시할 내용이 없습니다.",
              info: "_TOTAL_ 개의 항목 중 _START_ ~ _END_",
              infoFiltered: " (전체 _MAX_ 개)",
              lengthMenu: "페이지 당 _MENU_ 항목 표시",
              search: "",
              searchPlaceholder: "제목, 작성자 검색",
              paginate: {
                first: "«",
                previous: "‹",
                next: "›",
                last: "»"
              },
              aria: {
                paginate: {
                  first: "First",
                  previous: "Previous",
                  next: "Next",
                  last: "Last"
                }
              }
            },
            search: "",
            searchDelay: 500,
            order: [[0, "desc"]],
            serverSide: true,
            ajax: {
              url: "/admin/ajax/issue/butters",
              type: "GET",
              error: function(e) {
                if (e.status === 401 || e.status === 403)
                  window.location.reload();
                else window.location.href = "/admin/index.do";
              }
            },
            columns: [
              { data: "createdDate" },
              {
                data: function(item) {
                  return (
                    '<a href="/admin/issue/butter-detail.do?id=' +
                    item.id +
                    '">' +
                    item.title +
                    "</a>"
                  );
                },
                orderable: false
              },
              { data: "createdBy.name", orderable: false },
              { data: "stats.viewCount", orderable: false },
              { data: "stats.likeCount", orderable: false },
              { data: "stats.opinionCount", orderable: false },
              {
                data: function(item) {
                  if (item.status === "CLOSED") return "비공개";
                  if (item.status === "DELETE") return "삭제";
                  if (item.status === "BLOCK") return "비공개";
                  return "공개";
                },
                orderable: false
              }
            ]
          });
      });
    </script>
    <style>
      .table > tbody > tr > td,
      .table > tbody > tr > th,
      .table > tfoot > tr > td,
      .table > tfoot > tr > th,
      .table > thead > tr > td,
      .table > thead > tr > th {
        vertical-align: middle;
      }

      .modal label {
        width: 100%;
      }

      span.label {
        font-size: 90%;
      }
    </style>
  </body>
</html>
