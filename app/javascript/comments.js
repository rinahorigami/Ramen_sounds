document.addEventListener("turbo:load", () => {
  // コメントアイコンをクリックしてコメント欄を表示
  document.querySelectorAll(".fa-comment").forEach(icon => {
    icon.addEventListener("click", function() {
      const videoId = this.getAttribute("data-video-id");
      const commentSection = document.getElementById(`comment-section-${videoId}`);
      commentSection.style.display = "block";
    });
  });

  // 閉じるボタンをクリックしてコメント欄を非表示
  document.querySelectorAll(".close-comment-section").forEach(button => {
    button.addEventListener("click", function() {
      const videoId = this.getAttribute("data-video-id");
      const commentSection = document.getElementById(`comment-section-${videoId}`);
      commentSection.style.display = "none";
    });
  });
});