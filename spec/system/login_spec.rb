require 'rails_helper'

RSpec.describe 'ログイン機能', type: :system do
  let!(:user) { create(:user) } # FactoryBotでユーザーを作成

  it 'ユーザーが正しくログインできる' do
    # ログインページにアクセス
    visit login_path

    # ログインフォームに情報を入力
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password' # ユーザー作成時のパスワードを使用

    # ログインボタンをクリック
    click_button 'ログイン'

    # ログイン成功後の確認（フラッシュメッセージやリダイレクト先など）
    expect(page).to have_content('ログインしました。')
    expect(page).to have_current_path(videos_path)
  end

  it '誤った情報でログインに失敗する' do
    # ログインページにアクセス
    visit login_path

    # 誤った情報を入力
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'wrongpassword' # 誤ったパスワード

    # ログインボタンをクリック
    click_button 'ログイン'

    # ログイン失敗後の確認
    expect(page).to have_content('メールアドレスまたはパスワードが違います。')
    expect(page).to have_current_path(login_path) # 再びログインページに戻されるか確認
  end
end
