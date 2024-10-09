document.addEventListener('turbo:load', function() {
  const form = document.querySelector('.custom-form');
  const loadingElement = document.getElementById('loading-video'); // IDを変更

  if (form) {
    // フォーム送信開始時にローディングアニメーションを表示
    form.addEventListener('turbo:submit-start', function() {
      if (loadingElement) {
        loadingElement.style.display = 'block'; // ローディングアニメーションを表示
      }
    });

    // フォーム送信完了後にローディングアニメーションを非表示にする
    form.addEventListener('turbo:submit-end', function() {
      if (loadingElement) {
        loadingElement.style.display = 'none'; // ローディングアニメーションを非表示
      }
    });
  }
});


