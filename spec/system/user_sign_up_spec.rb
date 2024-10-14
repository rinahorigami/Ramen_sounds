require 'rails_helper'

RSpec.describe 'ユーザー登録機能', type: :system do

  it 'ユーザーが正常に登録できる' do
    visit new_user_path # ユーザー登録ページに移動

    fill_in 'ユーザー名', with: 'テストユーザー'
    fill_in 'メールアドレス', with: Faker::Internet.unique.email
    fill_in 'user_password', with: 'password' # パスワードの入力
    fill_in 'user_password_confirmation', with: 'password' # パスワード確認の入力
    
    # ファイルアップロード (アバター画像を追加)
    attach_file 'avatar-input', Rails.root.join('spec/fixtures/avatar.png'), make_visible: true

    # フォーム送信
    click_button '登録'

    expect(page).to have_current_path(videos_path)
    expect(page).to have_content('ユーザー登録が完了し、ログインしました。')
  end

  it 'ユーザー登録に失敗する (必須フィールドが未入力)' do
    visit new_user_path

    fill_in 'メールアドレス', with: 'test@example.com'
    fill_in 'user_password', with: 'password' # パスワードの入力
    fill_in 'user_password_confirmation', with: 'password' # パスワード確認の入力

    # ユーザー名が未入力のため、登録失敗
    click_button '登録'

    # エラーメッセージが表示されることを確認
    expect(page).to have_content('ユーザー登録に失敗しました。')
  end

  it 'パスワード確認が一致しない場合、登録に失敗する' do
    visit new_user_path

    fill_in 'ユーザー名', with: 'テストユーザー'
    fill_in 'メールアドレス', with: 'test@example.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'wrongpassword'

    # フォーム送信
    click_button '登録'

    # エラーメッセージが表示されることを確認
    expect(page).to have_content('ユーザー登録に失敗しました。')
  end
end
