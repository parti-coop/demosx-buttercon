$(function() {
  var $$csrf_token = $('meta[name="csrf-token"]').attr('content');
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

  $('.js-focus').on('click', function(e) {
    var $elm = $(e.currentTarget);
    var $target = $($elm.data('focus'));
    if($target.length > 0) {
      $target.focus();
    }
    return false;
  });

  (function() {
    $('.js-tinymce-editor').each(function(index, elm) {
      var protocol = location.protocol;
      var slashes = protocol.concat("//");
      var document_base_url = slashes.concat(window.location.hostname);
      var port = location.port;
      if(port) {
        document_base_url = document_base_url.concat(":").concat(port);
      }
      var $elm = $(elm);
      var content_css = $elm.data('tinymce-content-css');
      var upload_url = $elm.data('tinymce-upload-url');
      $elm.tinymce({
        cache_suffix: '?v=5.0.15.1',
        menubar: false,
        statusbar: false,
        toolbar_drawer: 'sliding',
        language: 'ko_KR',
        min_height: 200,
        document_base_url: document_base_url,
        content_css: content_css,
        link_context_toolbar: false,
        link_assume_external_targets: 'http',
        target_list: false,
        relative_urls: false,
        remove_script_host : false,
        hidden_input: false,
        uploadimage_default_img_class: 'tinymce-content-image',
        link_title: false,
        plugins: ['autolink', 'autosave', 'textcolor', 'image', 'media', 'link', 'paste', 'autoresize'],
        toolbar: "undo redo | styleselect | forecolor bold italic | alignleft aligncenter alignright alignjustify | link media custom_image",
        mobile: {
          theme: 'silver',
        },
        branding: false,
        preview_styles: 'font-family font-size color',
        body_class: 'tinymce-container',
        setup: function (editor) {
          if(!upload_url) {
            return;
          }

          var $editor = editor;
          var $upload_control;
          $upload_control = $("<input type=\"file\" name=\"file\" class=\"hidden\" accept=\"image/*\">");
          $('body').append($upload_control);

          $upload_control.fileupload({
            headers: {
              'X-CSRF-TOKEN': $$csrf_token,
            },
            url: upload_url,
            acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
            maxFileSize: 10485760,
            dataType: 'json',
            done: function (e, data) {
              $editor.execCommand('mceInsertContent', false, '<img src="' + data.result.url + '" alt="' + data.result.filename  + '"/>');
            },
            progressall: function (e, data) {
            },
            fail: function (e, data) {
              alert(data.jqXHR.responseJSON.msg);
            },
            messages: {
              acceptFileTypes: 'GIF, JPG, PNG 형식의 이미지만 업로드됩니다.' ,
              maxFileSize:  '10M 이하의 이미지만 업로드됩니다',
            }
          })
          .prop('disabled', !$.support.fileInput)
          .parent().addClass($.support.fileInput ? undefined : 'disabled');

          editor.ui.registry.addButton('custom_image', {
            title: '이미지삽입',
            icon: 'image',
            onAction: function() {
              if($upload_control) {
                $upload_control.click();
              } else {
                alert("앗! 뭔가 잘못되었습니다. 페이지를 새로고침하세요.");
              }
            }
          });
        }
      });
    });
  })();
});