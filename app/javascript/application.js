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

      // 位置情報がブロックされた場合、デフォルトの東京を表示するためにページを遷移
      const searchUrl = document.getElementById('find-location-link').getAttribute('data-search-url');
      const fullUrl = `${searchUrl}?lat=35.6895&lng=139.6917&from_current_location=false`;  // 東京の緯度経度をセット
      window.location.href = fullUrl;  // 東京を中心にしたURLへ遷移
    }
  );
} else {
  alert("ブラウザが位置情報取得に対応していません。");
  // ブラウザが対応していない場合も東京を中心に表示
  const searchUrl = document.getElementById('find-location-link').getAttribute('data-search-url');
  const fullUrl = `${searchUrl}?lat=35.6895&lng=139.6917&from_current_location=false`;  // 東京の緯度経度をセット
  window.location.href = fullUrl;  // 東京を中心にしたURLへ遷移
}
}

// 位置情報map表示
const RamenMap = {
  mapInitialized: false,
  map: null,

  init: function(position) {
    const userLocation = {
      lat: position.coords.latitude,
      lng: position.coords.longitude
    };

    this.map = new google.maps.Map(document.getElementById("user-map"), {
      zoom: 15,
      center: userLocation
    });

    this.createUserMarker(userLocation, this.map);

    // 地図の移動後に周辺のラーメン店を自動検索
    this.addIdleListener();
    
    // 初回の店舗検索
    this.searchNearby();
  },

  createUserMarker: function(location, map) {
    const marker = new google.maps.Marker({
      position: location,
      map: map,
      title: "あなたの現在地"
    });
  },

  createMarker: function(place, map) {
    const marker = new google.maps.Marker({
      position: place.geometry.location,
      map: map,
      title: place.name,
      icon: {
        url: ramenIconPath,
        scaledSize: new google.maps.Size(40, 40)
      }
    });

    const infoWindow = new google.maps.InfoWindow({
      content: `<div><strong>${place.name}</strong></div>`
    });

    marker.addListener('click', function() {
      infoWindow.open(map, marker);
    });
  },

  searchNearby: function() {
    if (!this.map) return;

    const center = this.map.getCenter();  // マップの中心を取得

    const request = {
      location: center,
      radius: '2000',
      type: ['restaurant'],
      keyword: 'らーめん 油そば'
    };

    const service = new google.maps.places.PlacesService(this.map);
    const self = this;

    service.nearbySearch(request, (results, status, pagination) => {
      if (status === google.maps.places.PlacesServiceStatus.OK) {
        for (let i = 0; i < results.length; i++) {
          const place = results[i];
          self.createMarker(place, self.map);
        }

        // 次のページの結果がある場合
        if (pagination && pagination.hasNextPage) {
          setTimeout(() => {
            pagination.nextPage();
          }, 2000);
        }
      } else {
        console.error("Places APIエラー: ", status);
      }
    });
  },

  initDefaultMap: function() {
    const tokyo = { lat: 35.6895, lng: 139.6917 };
    this.map = new google.maps.Map(document.getElementById("user-map"), {
      zoom: 15,
      center: tokyo
    });

    // 地図の移動後に周辺のラーメン店を自動検索
    this.addIdleListener();

    // 初回の店舗検索
    this.searchNearby();

    // 初期化済みとしてフラグを設定
    this.mapInitialized = true;

  },

  // 地図が静止した後（ユーザーが地図を移動やズームした後）に店舗検索を実行
  addIdleListener: function() {
    const self = this;
    this.map.addListener('idle', function() {
      self.searchNearby();  // 地図の表示範囲が変更された後に検索
    });
  }
};

// ページロード後にマップを初期化
document.addEventListener("turbo:load", function() {
  if (document.getElementById("user-map") && !RamenMap.mapInitialized) {
    if (navigator.geolocation) {
      // 位置情報の取得を試みる
      navigator.geolocation.getCurrentPosition(
        function(position) {
          // 位置情報の取得に成功した場合、ユーザーの位置を使用
          RamenMap.init(position);
        },
        function() {
          // 位置情報の取得に失敗した場合、東京を中心にしたマップを表示
          RamenMap.initDefaultMap();
        }
      );
    } else {
      // ブラウザが位置情報取得に対応していない場合も東京を表示
      RamenMap.initDefaultMap();
    }
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