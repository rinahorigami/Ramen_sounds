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