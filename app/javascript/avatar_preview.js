document.addEventListener('turbo:load', () => {
  const fileInput = document.getElementById('avatar-input');
  const selectAvatarBtn = document.getElementById('select-avatar-btn');

  if (selectAvatarBtn && fileInput) {
    selectAvatarBtn.addEventListener('click', () => {
      fileInput.click();
    });
  }

  if (fileInput) {
    fileInput.addEventListener('change', previewImage);
  }
});

function previewImage(event) {
  const reader = new FileReader();
  reader.onload = function() {
    const output = document.getElementById('avatar-preview');
    if (output) {
      output.src = reader.result;
      output.style.display = 'block';
    }
  };
  if (event.target.files[0]) {
    reader.readAsDataURL(event.target.files[0]);
  }
}