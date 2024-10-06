document.addEventListener('turbo:load', function() {
  // フォーム全体のリセット処理
  const form = document.getElementById('search-form');

  if (!form) {
    console.error('search-form が見つかりません。');
    return;  // ここで終了して以降の処理を行わない
  }

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
});
