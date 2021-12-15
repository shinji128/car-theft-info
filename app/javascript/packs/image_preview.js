document.addEventListener('DOMContentLoaded', () => {
  $(function(){
    function buildHTML(count) {
      const html = `<div class="preview-box" id="preview-box-${count}">
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
      const prevContent = $('.label-content').prev();
      labelWidth = (620 - $(prevContent).css('width').replace(/[^0-9]/g, ''));
      $('.label-content').css('width', labelWidth);
    }

    function UpdateId(id) {
      $('.label-box').attr({id: `label-box-${id}`,for: `post_image_${id}`});
      $('.hidden-field').attr({id: `post_image_${id}`});
    }

    $(document).on('change', '.hidden-field', function() {
      const id = $(this).attr('id').replace(/[^0-9]/g, '');
      UpdateId(id);
      const file = this.files[0];
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function() {
        const image = this.result;
        if ($(`#preview-box-${id}`).length == 0) {
          const html = buildHTML(id);
          const prevContent = $('.label-content').prev();
          $(prevContent).append(html);
        }
        $(`#preview-box-${id} img`).attr('src', `${image}`);
        const count = $('.preview-box').length;
        if (count < 5) UpdateId(count);
        if (count == 5) $('.label-content').hide();
        setLabel();
      }
    });

    $(document).on('click', '.delete-box', function() {
      const count = $('.preview-box').length;
      const id = $(this).attr('id').replace(/[^0-9]/g, '');
      $(`#preview-box-${id}`).remove();
      $(`#post_image_${id}`).val("");
      if (count == 5) $('.label-content').show();
      if (id < 5) UpdateId(id);
      setLabel();
    });
  });
})
