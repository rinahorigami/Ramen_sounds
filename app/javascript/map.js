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
    this.searchNearby(map);
    this.addIdleListener(map);
  },

  // user-map 用の初期化
  initUserMap: function(position) {
    const latitude = position.coords.latitude;
    const longitude = position.coords.longitude;
    const map = this.createMap(latitude, longitude, "user-map");

    this.addUserMarker(map, latitude, longitude);
    this.searchNearby(map);
    this.addIdleListener(map);
  },

  // 位置情報をブロックした場合のuser-map用の初期化
  initDefaultLocationMap: function(latitude, longitude) {
    const map = this.createMap(latitude, longitude, "user-map");
    this.searchNearby(map);
    this.addIdleListener(map);
  },

  // store-map 用の初期化
  initStoreMap: function(latitude, longitude) {
    const map = this.createMap(latitude, longitude, "store-map");
    this.addStoreMarker(map, latitude, longitude);
  },

  // マーカーを作成してマップに追加する
  createMarker: function(place, map) {
    const marker = new google.maps.Marker({
      position: place.geometry.location,
      map: map,
      title: place.name,
      icon: {
        url: ramenIconPath, // ラーメン店の独自アイコン
        scaledSize: new google.maps.Size(40, 40)
      }
    });
  
    // 現在のURLからfrom_video_formとvideo_idパラメータを取得
    const urlParams = new URLSearchParams(window.location.search);
    const fromVideoForm = urlParams.get('from_video_form');
    const videoId = urlParams.get('video_id');

    // 店舗名をクリックした際に遷移するリンクを含む InfoWindow を作成
    const infoWindow = new google.maps.InfoWindow({
      content: `<div><strong><a href="/ramen_shops/${place.place_id}?from_video_form=${fromVideoForm || ''}&video_id=${videoId || ''}">${place.name}</a></strong><br>${place.vicinity || ''}</div>` // 店舗名や住所を表示
    });
  
    // マーカーがクリックされた時に InfoWindow を表示
    marker.addListener('click', function() {
      infoWindow.open(map, marker);
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
  setTimeout(() => {
    const userMapElement = document.getElementById("user-map");
    console.log("userMapElement:", userMapElement);

    if (userMapElement) {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
          function(position) {
            RamenMap.initUserMap(position);
          },
          function() {
            console.log("位置情報の取得に失敗。デフォルトの東京を表示します。");
            RamenMap.initDefaultLocationMap(35.6895, 139.6917);
          }
        );
      } else {
        console.log("位置情報取得に対応していません。デフォルトの東京を表示します。");
        RamenMap.initDefaultLocationMap(35.6895, 139.6917);
      }
    } else {
      console.error("userMapElementが見つかりません");
    }
  }, 100);

  // store-map の場合
  const storeMapElement = document.getElementById("store-map");
  if (storeMapElement) {
    const latitude = parseFloat(storeMapElement.getAttribute("data-latitude"));
    const longitude = parseFloat(storeMapElement.getAttribute("data-longitude"));
    RamenMap.initStoreMap(latitude, longitude);
  }
});