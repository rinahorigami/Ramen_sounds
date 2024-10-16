# サービス名：Ramen　sounds

## 概要
Ramen soundsは、ラーメンを食べる音を動画で投稿し、他のユーザーと共有するユニークなアプリです。
ASMRコンテンツとしてラーメン動画を楽しむことができ、ラーメン店探しも可能なサービスです。

## このサービスへの思い・作りたい理由
ラーメンを食べることが好きで、ASMR動画を見るのも楽しんでいます。
ラーメンレビューアプリは多いですが、ラーメン店探しとASMR動画を組み合わせたアプリはありません。
ラーメン店探しとASMR動画の両方を楽しめるアプリを作りたいと思いました。

## 想定されるユーザー層
**ラーメンが好きな人**：新しいラーメン店を発見するのが好きな人や、自分のラーメン体験を共有したい人。

**ラーメン店探しをしている人**：美味しいラーメン店を探している人や、新しい店を試したい人。

**ASMR動画を見るのが好きな人**：食べる音や料理の音を楽しむことが好きな人。

## サービスの利用イメージ

### ラーメン動画の視聴と共有
1. **ASMRコンテンツとしての楽しみ**: 
   - ユーザーはアプリを開き、ホーム画面でおすすめのラーメンASMR動画を視聴します。動画を見ながらリラックスし、ラーメンの音を楽しむことができます。
   - 動画には投稿者が食べたラーメン店の詳細情報が表示されており、興味をもったユーザーはその店の詳細を確認することができます。
2. **動画の投稿と共有**: 
   - ユーザーは自分のラーメン体験を動画に収め、簡単な説明を付けてアプリに投稿します。投稿時に、Google Places APIを利用して訪れたラーメン店を検索し、詳細情報を自動的に入力することができます。
   - 他のユーザーは新着動画や人気動画を閲覧し、いいねやコメントを残すことができます。

### ラーメン店の検索とレビュー
1. **ラーメン店探し**:
   - アプリ内の検索機能を利用して、店名や場所でラーメン店検索ができます。自分の位置情報を基に近くのラーメン店を探すことができる機能も追加予定です。
2. **動画レビュー**:
   - 各ラーメン店のページには、その店で撮影されたASMR動画の一覧が表示されます。ユーザーはこれらの動画を視聴し、店の雰囲気や料理の音からその店のラーメンを体験することができます。

## サービスの差別化ポイント
ラーメン店探しとASMR動画を組み合わせた唯一のアプリです。ラーメンレビューアプリとは異なり、食べる音の体験を重視しています。
ユーザーが視覚だけでなく聴覚でもラーメン体験を楽しむことができ、音を通じて新しいラーメン店を発見する楽しさが体験できます。

### 使い方　
| トップページ | ラーメン店検索ページ |
| ---- | ---- |
| [![Image from Gyazo](https://i.gyazo.com/2426250b4f6c915d2a1f8f8470700c4f.gif)](https://gyazo.com/2426250b4f6c915d2a1f8f8470700c4f) | [![Image from Gyazo](https://i.gyazo.com/4e3c54429212e4ce8db839502e2646e4.gif)](https://gyazo.com/4e3c54429212e4ce8db839502e2646e4) |
| 下にスクロールするとサイト説明があります。<br>サイトについてというリンクをクリックしても自動でスクロールされるようにしています。<br> | 店舗名・場所・タグの3種類からラーメン店を検索できます。<br>場所検索は地名を検索するとその地名がマップで表示され、マップ上でラーメン店を検索できます。<br>マップのラーメン店にアイコンを表示させて、どこにラーメン店があるか一目でわかるようにしてます。<br>タグ検索では、そのタグをつけている動画を検索できます。|

| 動画一覧ページ | 動画投稿ページ |
| ---- | ---- |
| [![Image from Gyazo](https://i.gyazo.com/6732afcccdbc4fabecdc2b4311c0c974.gif)](https://gyazo.com/6732afcccdbc4fabecdc2b4311c0c974) | [![Image from Gyazo](https://i.gyazo.com/c29e1c74a39f62d1ed3d77073c761f39.gif)](https://gyazo.com/c29e1c74a39f62d1ed3d77073c761f39) |
| みんなが投稿した動画を一覧で見ることができます。<br>店名のリンクをクリックすると、動画に関連づけられたラーメン店の詳細ページに遷移します。<br>好きな動画にいいねやコメントを投稿できます。 | ラーメン店を選択ボタンをクリックすると、検索フォームに遷移するので、訪れたラーメン店を店名や場所で検索して動画に関連づけることができます。<br> 動画アップロード以外の項目は任意となっているので、動画だけを投稿することもできます。 |

### 画面遷移図
Figma:https://www.figma.com/design/zJQgXh6dN3sgtxCP9BnY3V/%E7%84%A1%E9%A1%8C?node-id=0-1&t=TlRn1UQq35jMo61p-1
### ER図
https://gyazo.com/885dd2fabc0a9439c8d1d6ac191ed88c

## 機能一覧
- ユーザー登録
- ログイン
- Google認証
- オートログイン
- パスワードリセット
- 動画投稿
  - メニュー名
  - 金額
  - コメント
  - ラーメン店関連付け
  - タグ付け
  - 動画アップロード
- 投稿動画一覧
- いいね
- コメント
- ユーザーの位置情報を取得してマップを表示（マップ上のラーメン店にアイコンを表示）
- 検索
  - 店舗名
  - 場所(マップ上で検索)
  - タグ(動画検索)
- オートコンプリート
- 店舗詳細
- マイページ
  - プロフィール編集(ユーザー名・email・アバター画像)
  - 投稿動画一覧
  - いいね動画一覧
  - 投稿動画の編集・削除
