<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ include
file="editor-script.jsp" %>
<script>
  function setSlack(url, channel) {
    $("input[name='slackUrl']").val(url);
    $("input[name='slackChannel']").val(channel);
  }
  $(function() {
    $(".maker-tagging").select2({
      language: "ko",
      tokenSeparators: [",", " "],
      multiple: true,
      ajax: {
        headers: { "X-CSRF-TOKEN": "${_csrf.token}" },
        url: "/ajax/butter/maker",
        type: "GET",
        contentType: "application/json",
        dataType: "json",
        processResults: function(data) {
          if (!data) {
            return;
          }
          var results = $.map(data, function(item, index) {
            return {
              id: item.id,
              text: item.name
            };
          });
          return { results };
        }
      }
    });

    var $formNewProposal = $("#form-new-proposal");
    $formNewProposal.parsley(parsleyConfig);
    $formNewProposal.on("submit", function(event) {
      if ($formNewProposal.data("submitting") === true) {
        return false;
      }
      event.preventDefault();
      $formNewProposal.data("submitting", true);
      var data = $formNewProposal.serializeObject();
      data.content = simplemde.value();
      $.ajax({
        headers: { "X-CSRF-TOKEN": "${_csrf.token}" },
        url: "/ajax/butter/",
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: JSON.stringify(data),
        success: function(data) {
          alert(data.msg);
          $formNewProposal[0].reset();
          $formNewProposal.parsley().reset();
          window.location.href = data.url;
        },
        error: function(error) {
          $formNewProposal.data("submitting", false);
          if (error.status === 400) {
            if (error.responseJSON.fieldErrors) {
              var msg = error.responseJSON.fieldErrors
                .map(function(item) {
                  return item.fieldError;
                })
                .join("/n");
              alert(msg);
            } else alert(error.responseJSON.msg);
          } else if (error.status === 403 || error.status === 401) {
            alert("로그인이 필요합니다.");
            window.location.href = "/login.do";
          }
        }
      });
    });
  });
</script>
