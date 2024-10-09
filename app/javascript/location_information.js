// 位置情報取得
document.addEventListener("turbo:load", function() {
  const locationLink = document.getElementById('find-location-link');
  const loadingElement = document.getElementById('loading-location'); // ローディング要素

  if (locationLink) {  // 要素が存在するか確認
    locationLink.addEventListener('click', function(event) {
      event.preventDefault(); // デフォルトのリンク動作をキャンセル

      // 位置情報取得開始時にローディングアニメーションを表示
      if (loadingElement) {
        loadingElement.style.display = 'block';
      }

      getLocationAndSearch();
    });
  }
});

function getLocationAndSearch() {
  const loadingElement = document.getElementById('loading-location'); // ローディング要素

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      const lat = position.coords.latitude;
      const lng = position.coords.longitude;

      console.log("Latitude: " + lat + ", Longitude: " + lng); // 緯度と経度をコンソールに出力

      const searchUrl = document.getElementById('find-location-link').getAttribute('data-search-url');
      const fullUrl = `${searchUrl}?lat=${lat}&lng=${lng}&from_current_location=true`;

      window.location.href = fullUrl;
    }, function(error) {
      console.error("位置情報の取得に失敗しました: ", error);
      alert("位置情報を取得できませんでした。東京を中心に表示します。");

      const searchUrl = document.getElementById('find-location-link').getAttribute('data-search-url');
      const fullUrl = `${searchUrl}?lat=35.6895&lng=139.6917&from_current_location=false`;  // 東京の緯度経度をセット
      window.location.href = fullUrl;  // 東京を中心にしたURLへ遷移
    }, function() {
      // 成功・失敗にかかわらず、ローディングアニメーションを非表示にする
      if (loadingElement) {
        loadingElement.style.display = 'none';
      }
    });
  } else {
    alert("ブラウザが位置情報取得に対応していません。");

    const searchUrl = document.getElementById('find-location-link').getAttribute('data-search-url');
    const fullUrl = `${searchUrl}?lat=35.6895&lng=139.6917&from_current_location=false`;  // 東京の緯度経度をセット
    window.location.href = fullUrl;  // 東京を中心にしたURLへ遷移

    // 位置情報取得失敗時にローディングアニメーションを非表示にする
    if (loadingElement) {
      loadingElement.style.display = 'none';
    }
  }
}
