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
    const marker = new google.maps.Marker({
      position: place.geometry.location,
      map: map,
      title: place.name,
      icon: {
        url: ramenIconPath, // ラーメン店の独自アイコン
        scaledSize: new google.maps.Size(40, 40)
      }
    });
  
    // 店舗名をクリックした際に遷移するリンクを含む InfoWindow を作成
    const infoWindow = new google.maps.InfoWindow({
      content: `<div><strong><a href="/ramen_shops/${place.place_id}">${place.name}</a></strong><br>${place.vicinity || ''}</div>` // 店舗名や住所を表示
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