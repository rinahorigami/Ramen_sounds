// 切り替える背景画像のリスト
const backgrounds = [
  'url("/images/AdobeStock_343708014.jpg")',
  'url("/images/AdobeStock_233343975.jpeg")',
  'url("/images/AdobeStock_204177687.jpeg")',
  'url("/images/AdobeStock_478152704.jpeg")'
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

// 3秒ごとに背景画像を切り替える
setInterval(changeBackground, 3000);

// 初期化
document.getElementById('background1').style.backgroundImage = backgrounds[0];
document.getElementById('background1').classList.add('active');
