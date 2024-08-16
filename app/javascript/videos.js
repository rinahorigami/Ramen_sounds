function showFileName() {
  const fileInput = document.getElementById('video_file');
  const fileNameSpan = document.getElementById('file-name');

  if (fileInput && fileNameSpan) {
    const files = fileInput.files;
    if (files.length > 0) {
      fileNameSpan.textContent = files[0].name;
    } else {
      fileNameSpan.textContent = "選択されたファイルはありません";
    }
  } else {
    console.error("ファイル入力またはスパンが見つかりません");
  }
}

document.addEventListener('turbo:load', () => {
  const fileInput = document.getElementById('video_file');
  if (fileInput) {
    fileInput.addEventListener('change', showFileName);
  }
});

document.addEventListener('turbo:load', () => {
    const videos = document.querySelectorAll('.reel-item video');
  
    videos.forEach(video => {
      video.addEventListener('play', () => {
        videos.forEach(v => {
          if (v !== video && !v.paused) {
            v.pause();
          }
        });
      });
    });
});