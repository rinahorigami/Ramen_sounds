document.addEventListener('DOMContentLoaded', () => {
  const fileInput = document.getElementById('avatar-input');
  const selectAvatarBtn = document.getElementById('select-avatar-btn');

  selectAvatarBtn.addEventListener('click', () => {
    fileInput.click();
  });

  fileInput.addEventListener('change', previewImage);
});

function previewImage(event) {
  const reader = new FileReader();
  reader.onload = function() {
    const output = document.getElementById('avatar-preview');
    output.src = reader.result;
    output.style.display = 'block';
  };
  reader.readAsDataURL(event.target.files[0]);
}