// 切り替える背景画像のリスト
const backgrounds = [
  'url("/images/AdobeStock_343708014_11zon.webp")',
  'url("/images/AdobeStock_233343975_11zon.webp")',
  'url("/images/AdobeStock_204177687_11zon.webp")',
  'url("/images/AdobeStock_478152704_11zon.webp")'
];

let currentIndex = 0;
let activeIndex = 0; // どちらの背景を表示するかを示す

// 背景画像を切り替える関数
function changeBackground() {
  // 背景要素を取得
  const backgroundsElements = [
    document.getElementById('background1'),
    document.getElementById('background2')
  ];

  // 要素が存在する場合のみ処理を実行
  if (backgroundsElements[0] && backgroundsElements[1]) {
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
}

// ページに背景要素が存在する場合のみ初期化
if (document.getElementById('background1')) {
  document.getElementById('background1').style.backgroundImage = backgrounds[0];
  document.getElementById('background1').classList.add('active');

  // 3秒ごとに背景画像を切り替える
  setInterval(changeBackground, 3000);
}
