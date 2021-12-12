document.addEventListener('DOMContentLoaded', () => {
  $(function(){
    function buildHTML(count) {
      var html = `<div class="preview-box" id="preview-box-${count}">
                    <div class="image-box">
                      <img src="" alt="preview">
                    </div>
                    <div class="delete-box" id="delete-btn-${count}">
                      <span>削除</span>
                    </div>
                  </div>`
      return html;
    }

    function setLabel() {
      var prevContent = $('.label-content').prev();
      labelWidth = (620 - $(prevContent).css('width').replace(/[^0-9]/g, ''));
      $('.label-content').css('width', labelWidth);
    }

    $(document).on('change', '.hidden-field', function() {
      setLabel();
      var id = $(this).attr('id').replace(/[^0-9]/g, '');
      console.log(id)
      $('.label-box').attr({id: `label-box-${id}`,for: `post_image_${id}`});
      $('.hidden-field').attr({id: `post_image_${id}`});
      var file = this.files[0];
      var reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function() {
        var image = this.result;
        if ($(`#preview-box-${id}`).length == 0) {
          var count = $('.preview-box').length;
          var html = buildHTML(id);
          var prevContent = $('.label-content').prev();
          $(prevContent).append(html);
        }
        $(`#preview-box-${id} img`).attr('src', `${image}`);
        var count = $('.preview-box').length;
        if (count == 5) {
          $('.label-content').hide();
        }

        setLabel();
        if(count < 5){
          $('.label-box').attr({id: `label-box-${count}`, for: `post_image_${count}`});
          $('.hidden-field').attr({id: `post_image_${count}`});
        }
      }
    });

    $(document).on('click', '.delete-box', function() {
      var count = $('.preview-box').length;
      setLabel(count);
      var id = $(this).attr('id').replace(/[^0-9]/g, '');
      $(`#preview-box-${id}`).remove();
      console.log("new")
      $(`#post_image_${id}`).val("");
      var count = $('.preview-box').length;
      if (count == 4) {
        $('.label-content').show();
      }
      setLabel(count);

      if(id < 5){
        $('.label-box').attr({id: `label-box-${id}`,for: `post_image_${id}`});
        $('.hidden-field').attr({id: `post_image_${id}`});
      }
    });
  });
})
