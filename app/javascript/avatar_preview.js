document.addEventListener('DOMContentLoaded', () => {
    const fileInput = document.querySelector('input[type="file"][name="user[avatar]"]');
    if (fileInput) {
      fileInput.addEventListener('change', previewImage);
    }
  });
  
  function previewImage(event) {
    var reader = new FileReader();
    reader.onload = function() {
      var output = document.getElementById('avatar-preview');
      output.src = reader.result;
      output.style.display = 'block';
    };
    reader.readAsDataURL(event.target.files[0]);
  }