$(function() {
  $('.js-tagging').select2({
    language: "ko",
    tags: true,
    tokenSeparators: [',', ' '],
    createSearchChoice: function(term, data) {
      if ($(data).filter(function() {
        return this.text.localeCompare(term) === 0;
      }).length === 0) {
        return {
          id: term,
          text: term
        };
      }
    },
    multiple: true,
    ajax: {
      url: '/ajax/mypage/issuetags',
      type: 'GET',
      contentType: 'application/json',
      dataType: 'json',
      processResults: function (data) {
        if(!data) {
          return;
        }
        var results = $.map(data, function(item, index) {
          return {
            'id': item.name,
            'text': item.name,
          };
        });
        return {
          'results': results,
        };
      },
    }
  });
});