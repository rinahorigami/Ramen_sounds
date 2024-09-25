document.addEventListener('turbo:load', function() {
  // フォーム全体のリセット処理
  const form = document.getElementById('search-form');
    
  document.getElementById('tab-name').addEventListener('click', function() {
    form.reset();  // フォームをリセット
  });
  document.getElementById('tab-location').addEventListener('click', function() {
    form.reset();
  });
  document.getElementById('tab-tag').addEventListener('click', function() {
    form.reset();
  });
});