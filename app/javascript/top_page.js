document.addEventListener('turbo:load', function() {
  const backgrounds = [
    'url("/images/AdobeStock_343708014.jpg")',
    'url("/images/AdobeStock_233343975.jpeg")',
    'url("/images/AdobeStock_204177687.jpeg")',
    'url("/images/AdobeStock_478152704.jpeg")'
  ];

  let currentIndex = 0;
  let activeIndex = 0;
  let intervalId;

  // 背景画像を切り替える関数
  function changeBackground() {
    const backgroundsElements = [
      document.getElementById('background1'),
      document.getElementById('background2')
    ];

    // 要素が取得できているか確認
    if (!backgroundsElements[0] || !backgroundsElements[1]) {
      console.error("背景要素が見つかりません。");
      clearInterval(intervalId); // エラーが発生したらsetIntervalを停止
      return;
    }

    // 次の画像のインデックス
    currentIndex = (currentIndex + 1) % backgrounds.length;

    // 次に切り替える要素を取得し、新しい画像をセット
    const nextElement = backgroundsElements[(activeIndex + 1) % 2];
    nextElement.style.backgroundImage = backgrounds[currentIndex];

    // 非表示にしていた要素を表示、現在のアクティブな要素を非表示にする
    nextElement.classList.add('active');
    backgroundsElements[activeIndex].classList.remove('active');

    // アクティブ要素のインデックスを切り替え
    activeIndex = (activeIndex + 1) % 2;
  }

  // 初期化
  const backgroundElement1 = document.getElementById('background1');
  if (backgroundElement1) {
    backgroundElement1.style.backgroundImage = backgrounds[0];
    backgroundElement1.classList.add('active');

    // 5秒ごとに背景画像を切り替える
    intervalId = setInterval(changeBackground, 3000);
  } else {
    console.error("初期背景要素が見つかりません。");
  }
});