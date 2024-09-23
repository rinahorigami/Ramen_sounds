// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", () => {
  // コメントアイコンをクリックしてコメント欄を表示
  document.querySelectorAll(".comment-icon").forEach(icon => {
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


// 位置情報取得
document.addEventListener("turbo:load", function() {
  const locationLink = document.getElementById('find-location-link');
  
  if (locationLink) {  // 要素が存在するか確認
    locationLink.addEventListener('click', function(event) {
      event.preventDefault(); // デフォルトのリンク動作をキャンセル
      getLocationAndSearch();
    });
  }
});

function getLocationAndSearch() {
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
    });
  } else {
    alert("ブラウザが位置情報取得に対応していません。");

    const searchUrl = document.getElementById('find-location-link').getAttribute('data-search-url');
    const fullUrl = `${searchUrl}?lat=35.6895&lng=139.6917&from_current_location=false`;  // 東京の緯度経度をセット
    window.location.href = fullUrl;  // 東京を中心にしたURLへ遷移
  }
}

// 位置情報map表示
const RamenMap = {
  map: null,

  // 共通の初期化処理
  createMap: function(latitude, longitude, mapElementId, zoom = 15) {
    const location = {
      lat: latitude,
      lng: longitude
    };
    this.map = new google.maps.Map(document.getElementById(mapElementId), {
      zoom: zoom,
      center: location
    });

    return this.map;
  },

  // location-map 用の初期化
  initLocationMap: function(latitude, longitude) {
    const map = this.createMap(latitude, longitude, "location-map");
    // ラーメン店のマーカーを追加
    this.searchNearby(map);
    // マップが移動やズームされた後に再検索
    this.addIdleListener(map);
  },

  // user-map 用の初期化
  initUserMap: function(position) {
    const latitude = position.coords.latitude;
    const longitude = position.coords.longitude;
    const map = this.createMap(latitude, longitude, "user-map");

    // ユーザーの位置にマーカーを表示
    this.addUserMarker(map, latitude, longitude);
    this.searchNearby(map); // 周辺のラーメン店を検索してマーカーを表示
    this.addIdleListener(map); // マップ移動後の再検索を追加
  },

  // store-map 用の初期化
  initStoreMap: function(latitude, longitude) {
    const map = this.createMap(latitude, longitude, "store-map");
    // 店舗のマーカーを追加
    this.addStoreMarker(map, latitude, longitude);
  },

  // マーカーを作成してマップに追加する
  createMarker: function(place, map) {
    new google.maps.Marker({
      position: place.geometry.location,
      map: map,
      title: place.name,
      icon: {
        url: ramenIconPath, // ラーメン店の独自アイコン
        scaledSize: new google.maps.Size(40, 40)
      }
    });
  },

  // ユーザーの位置にマーカーを追加
  addUserMarker: function(map, latitude, longitude) {
    new google.maps.Marker({
      position: { lat: latitude, lng: longitude },
      map: map,
      title: "あなたの現在地"
    });
  },

  // 店舗にマーカーを追加
  addStoreMarker: function(map, latitude, longitude) {
    new google.maps.Marker({
      position: { lat: latitude, lng: longitude },
      map: map,
      title: "店舗の位置"
    });
  },

  // 周辺検索の処理（Google Places APIを使用）
  searchNearby: function(map) {
    const service = new google.maps.places.PlacesService(map);
    const request = {
      location: map.getCenter(),
      radius: '2000', // 検索範囲（メートル単位）
      type: ['restaurant'],
      keyword: 'ラーメン' // ラーメン店を検索
    };

    const self = this; // コンテキストを保持

    service.nearbySearch(request, function(results, status) {
      if (status === google.maps.places.PlacesServiceStatus.OK) {
        results.forEach(function(place) {
          self.createMarker(place, map); // ラーメン店にマーカーを追加
        });
      } else {
        console.error("周辺検索に失敗しました: ", status);
      }
    });
  },

  // マップが静止した後にラーメン店を再検索
  addIdleListener: function(map) {
    const self = this;
    map.addListener('idle', function() {
      self.searchNearby(map);  // 地図の表示範囲が変更された後に検索
    });
  }
};

// ページロード後に適切なマップを初期化する
document.addEventListener("turbo:load", function() {
  // location-map の場合
  const locationMapElement = document.getElementById("location-map");
  if (locationMapElement) {
    const latitude = parseFloat(locationMapElement.getAttribute("data-latitude"));
    const longitude = parseFloat(locationMapElement.getAttribute("data-longitude"));
    RamenMap.initLocationMap(latitude, longitude);
  }

  // user-map の場合
  if (document.getElementById("user-map")) {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        function(position) {
          RamenMap.initUserMap(position);
        },
        function() {
          RamenMap.initLocationMap(35.6895, 139.6917); // 東京をデフォルトに
        }
      );
    } else {
      RamenMap.initLocationMap(35.6895, 139.6917); // 東京をデフォルトに
    }
  }

  // store-map の場合
  const storeMapElement = document.getElementById("store-map");
  if (storeMapElement) {
    const latitude = parseFloat(storeMapElement.getAttribute("data-latitude"));
    const longitude = parseFloat(storeMapElement.getAttribute("data-longitude"));
    RamenMap.initStoreMap(latitude, longitude);
  }
});

// マイページ用
document.addEventListener("turbo:load", function() {
  const tabLinks = document.querySelectorAll(".tab-link");
  const tabContents = document.querySelectorAll(".tab-content");

  tabLinks.forEach(function(link) {
    link.addEventListener("click", function() {
      // 全てのタブリンクとタブコンテンツをリセット
      tabLinks.forEach(l => l.classList.remove("active"));
      tabContents.forEach(c => c.classList.remove("active"));

      // クリックしたタブリンクと対応するコンテンツをアクティブ化
      link.classList.add("active");
      const tabId = link.getAttribute("data-tab");
      document.getElementById(tabId).classList.add("active");
    });
  });
});

document.addEventListener("turbo:load", function() {
  const searchInput = document.getElementById("search-keyword");
  const autocompleteList = document.getElementById("autocomplete-list");

  // オートコンプリート候補を表示する関数
  searchInput.addEventListener("input", function() {
    const keyword = this.value;
    const searchType = document.querySelector('input[name="search_type"]').value; // search_typeを取得

    // キーワードが一定以上の長さの場合のみオートコンプリートを行う
    if (keyword.length > 1) {
      fetch(`/ramen_shops/autocomplete?search_type=${searchType}&keyword=${keyword}`)
        .then(response => response.json())
        .then(data => {
          autocompleteList.innerHTML = ''; // リストをクリア
          data.forEach(item => {
            const listItem = document.createElement("li");
            listItem.textContent = item.name;
            listItem.classList.add("autocomplete-item");
            
            // リストアイテムをクリックした際に、フォームに反映する
            listItem.addEventListener("click", function() {
              searchInput.value = item.name; // 候補を検索フィールドに設定
              autocompleteList.innerHTML = ''; // リストをクリア
            });

            autocompleteList.appendChild(listItem);
          });
        })
        .catch(error => console.error('Error:', error));
    } else {
      autocompleteList.innerHTML = ''; // 検索キーワードが短い場合はリストをクリア
    }
  });

  // フォーカスが外れた場合にオートコンプリートリストをクリア
  searchInput.addEventListener("blur", function() {
    setTimeout(function() {
      autocompleteList.innerHTML = ''; // リストをクリア
    }, 200); // setTimeoutの時間を少し長めにしてクリックイベントを処理
  });
});
