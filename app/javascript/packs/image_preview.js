if (document.URL.match("posts/new")){
  document.addEventListener('DOMContentLoaded', () => {
    const createImageHTML = (blob) => {
      const imageElement = document.getElementById('preview');

      const blobImage = document.createElement('img');
      blobImage.setAttribute('class', 'preview')
      blobImage.setAttribute('src', blob);

      imageElement.appendChild(blobImage);
    };
    document.getElementById('post_images').addEventListener('change', (e) =>{
      const file = e.target.files[0];
      const blob = window.URL.createObjectURL(file);
      createImageHTML(blob);
    });
  });
}
