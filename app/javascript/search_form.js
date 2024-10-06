document.addEventListener('turbo:load', function() {
  // フォーム全体のリセット処理
  const form = document.getElementById('search-form');
    
  if (form) {  // フォームが存在するか確認
    const tabName = document.getElementById('tab-name');
    const tabLocation = document.getElementById('tab-location');
    const tabTag = document.getElementById('tab-tag');

    // 各タブが存在する場合にのみ、リスナーを追加
    if (tabName) {
      tabName.addEventListener('click', function() {
        form.reset();
      });
    }

    if (tabLocation) {
      tabLocation.addEventListener('click', function() {
        form.reset();
      });
    }

    if (tabTag) {
      tabTag.addEventListener('click', function() {
        form.reset();
      });
    }
  } else {
    console.error("search-form が見つかりません。");
  }
});