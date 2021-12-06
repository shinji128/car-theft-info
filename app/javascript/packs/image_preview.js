document.addEventListener('DOMContentLoaded', () => {
  $(function(){
    //DataTransferオブジェクトで、データを格納する箱を作る
    var dataBox = new DataTransfer();
    //querySelectorでfile_fieldを取得
    var file_field = document.querySelector('input[type=file]')
    //fileが選択された時に発火するイベント
    $('#img-file').change(function(){
      //選択したfileのオブジェクトをpropで取得
      var files = $('input[type="file"]').prop('files')[0];
      $.each(this.files, function(i, file){
        //FileReaderのreadAsDataURLで指定したFileオブジェクトを読み込む
        var fileReader = new FileReader();

        //DataTransferオブジェクトに対して、fileを追加
        dataBox.items.add(file)
        //DataTransferオブジェクトに入ったfile一覧をfile_fieldの中に代入
        file_field.files = dataBox.files

        var num = $('.item-image').length + 1 + i
        fileReader.readAsDataURL(file);
        //画像が10枚になったら超えたらドロップボックスを削除する
        if (num == 5){
          $('#image-box__container').css('display', 'none')
        }
        //読み込みが完了すると、srcにfileのURLを格納
        fileReader.onloadend = function() {
          var src = fileReader.result
          var html= `<div class='item-image' data-image="${file.name}">
                      <div class=' item-image__content'>
                        <div class='item-image__content--icon'>
                          <img src=${src} width="171" height="144.25" >
                        </div>
                      </div>
                      <div class='item-image__operetion'>
                        <div class='item-image__operetion--delete'>削除</div>
                      </div>
                    </div>`
          //image_box__container要素の前にhtmlを差し込む
          $('#image-box__container').before(html);
        };
        //image-box__containerのクラスを変更し、CSSでドロップボックスの大きさを変えてやる。
        $('#image-box__container').attr('class', `item-num-${num}`)
      });
    });
    //削除ボタンをクリックすると発火するイベント
    $(document).on("click", '.item-image__operetion--delete', function(){
      //削除を押されたプレビュー要素を取得
      var target_image = $(this).parent().parent()
      //削除を押されたプレビューimageのfile名を取得
      var target_name = $(target_image).data('image')
      //プレビューがひとつだけの場合、file_fieldをクリア
      if(file_field.files.length==1){
        //inputタグに入ったファイルを削除
        $('input[type=file]').val(null)
        dataBox.clearData();
        console.log(dataBox)
      }else{
        //プレビューが複数の場合
        $.each(file_field.files, function(i,input){
          //削除を押された要素と一致した時、index番号に基づいてdataBoxに格納された要素を削除する
          if(input.name==target_name){
            dataBox.items.remove(i)
          }
        })
        //DataTransferオブジェクトに入ったfile一覧をfile_fieldの中に再度代入
        file_field.files = dataBox.files
      }
      //プレビューを削除
      target_image.remove()
      //image-box__containerクラスをもつdivタグのクラスを削除のたびに変更
      var num = $('.item-image').length
      $('#image-box__container').show()
      $('#image-box__container').attr('class', `item-num-${num}`)
    })
  });
});



// document.addEventListener('DOMContentLoaded', () => {
//   $(function(){
//     //DataTransferオブジェクトで、データを格納する箱を作る
//     var dataBox = new DataTransfer();
//     //querySelectorでfile_fieldを取得し変数に入れている
//     var file_field = document.querySelector('input[type=file]')

//     //file(#image-box)が変化した時に発火するイベント
//     $('#image-box').on("change",`input[type="file"]`,function(){
//       //選択したファイル情報を取得し変数に格納 - 最後の[0]は最初のファイルという意味
//       var files = $('input[type=file]').prop('files')[0];

//       //$.each()メソッドで、配列やハッシュに対して繰り返し処理を行う
//       $.each(this.files, function(i,file){

//         //FileReaderのreadAsDataURLで指定したFileオブジェクトを読み込む
//         var fileReader = new FileReader();

//         //DataTransferオブジェクトに対して、fileを追加
//         dataBox.items.add(file)

//         // file_fieldのnameに動的なindexをつける為の配列
//         let num = [1,2,3,4,5,6,7,8];
//         let img = [0,1,2,3,4,5,6,7];
//         // data()メソッドでindex番号を取得、lastを使って最後のinput[type="file"]を取得して変数に入れる
//         lastIndex = $('.input-field__contents:last').data('index');
//         anotherIndex = $('.input-field__contents:last').data('index');
//         //splice()メソッドを使い配列から要素を削除・追加して組み替える
//         num.splice(0, lastIndex);
//         img.splice(0, anotherIndex);

//         // 画像用のinputにそれぞれ異なる番号付与する記述
//         const buildFileField = (index)=> {
//           const html = `<div data-index="${index}" class="input-field__contents">
//                           <input id:"img-file" type="file"
//                           name="item[images_attributes][${index}][item_image]"
//                           id="item_images_attributes_${index}_item_image"><br>
//                         </div>`;
//           return html;
//         }

//         // buildFileFieldの変数に配列の０番目の番号入れて、image-box-2に加える
//         $('#image-box-2').append(buildFileField(num[0]));


//         //fileReader.readAsDataURL(file)で画像の読み込み。
//         fileReader.readAsDataURL(file);

//         //読み込みが完了すると、srcにfileのURLを格納
//         fileReader.onloadend = function() {
//           //resultプロパティで、読み込み成功後に、中身のデータを取得する
//           var src = fileReader.result

//           // 画像のプレビュー作成
//           var html = `<div class='item-image' data-image="${file.name}" data-index="${img[0]}">
//                         <div class=' item-image__content'>
//                           <div class='item-image__content--icon'>
//                             <img src=${src} width="140" height="150" >
//                           </div>
//                         </div>
//                         <div class='item-image__operetion'>
//                           <div class='item-image__operetion--delete' >削除</div>
//                         </div>
//                       </div>`
//           //image_box__container要素の前にhtmlを差し込む
//           $('#image-box__container').before(html);
//         };
//       });
//     });
//   });

//   //削除ボタンをクリックすると発火するイベント
//   $(document).on("click", '.item-image__operetion--delete', function(){
//     //プレビュー要素を取得
//     var target_image = $(this).parent().parent()
//     //プレビューを削除
//     target_image.remove();
//     //inputタグに入ったファイルを削除
//     file_field.val("")
//   })
//   //画像を追加した時に、labelのfor属性の値を新しいinputのidに変える記述
//   $(document).on("click", '#post_images', function(){
//     $('label').attr('for', 'item_images_attributes_1_item_image');
//   })
//   $(document).on("click", '#item_images_attributes_1_item_image', function(){
//     $('label').attr('for', 'item_images_attributes_2_item_image');
//   })
//   $(document).on("click", '#item_images_attributes_2_item_image', function(){
//     $('label').attr('for', 'item_images_attributes_3_item_image');
//   })
//   $(document).on("click", '#item_images_attributes_3_item_image', function(){
//     $('label').attr('for', 'item_images_attributes_4_item_image');
//   })
//   $(document).on("click", '#item_images_attributes_4_item_image', function(){
//     $('label').attr('for', 'item_images_attributes_5_item_image');
//   })
// });





// if (document.URL.match("posts/new")){
//   document.addEventListener('DOMContentLoaded', () => {
//     const createImageHTML = (blob) => {
//       const imageElement = document.getElementById('preview');

//       const blobImage = document.createElement('img');
//       blobImage.setAttribute('class', 'preview')
//       blobImage.setAttribute('src', blob);

//       imageElement.appendChild(blobImage);
//     };
//     document.getElementById('post_images').addEventListener('change', (e) =>{
//       const imageContent = document.querySelector('img');
//       if (imageContent){
//         imageContent.remove();
//       }

//       const file = e.target.files[0];
//       const blob = window.URL.createObjectURL(file);
//       createImageHTML(blob);
//     });
//   });
// }
