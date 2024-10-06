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

### 画面遷移図
Figma:https://www.figma.com/design/zJQgXh6dN3sgtxCP9BnY3V/%E7%84%A1%E9%A1%8C?node-id=0-1&t=TlRn1UQq35jMo61p-1
### ER図
https://gyazo.com/2d8df6cc835b5ca387111027c47dd790

## 実装を予定している機能
### MVP
- ユーザー登録
- ログイン
- 動画投稿
- 投稿一覧
- いいね
- 検索
  - 店舗名
  - 場所
  - タグ

### その後の機能
- 位置情報（Google Maps APIを利用）
- コメント

## 機能の実装方針予定
Google Places APIとGoogle Maps APIを使用してラーメン店の位置情報と詳細情報を取得
