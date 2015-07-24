@init_tinymce = (target_obj) ->
  tinymce.init
    selector: target_obj
    language: 'zh_TW'
    height: 400
    plugins: 'image table textcolor link emoticons'
    toolbar: [
      'undo redo | bold italic  underline | forecolor backcolor fontsizeselect'
      'insertfile | alignleft aligncenter alignright | table | link unlink | emoticons image'
    ]
    table_styles: 'table'
