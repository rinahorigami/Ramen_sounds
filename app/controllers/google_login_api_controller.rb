class GoogleLoginApiController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at(:google, prompt: 'select_account')
  end

  def callback
    provider = 'google'
    Rails.logger.debug("Params: #{params.inspect}")
    # 既存のユーザーをプロバイダ情報を元に検索し、存在すればログイン
    if (@user = login_from(provider))
      redirect_to videos_path, notice: t('notices.google_login_success', provider: provider.titleize)
    else
      begin
        signup_and_login(provider)
        redirect_to videos_path, notice: t('notices.google_login_success', provider: provider.titleize)
      rescue => e
        Rails.logger.error(e)
        redirect_to root_path, alert: t('notices.google_login_failure', provider: provider.titleize)
      end
    end
  end
  
  private

  def auth_params
    params.permit(:code, :provider).merge(provider: 'google')
  end

  def signup_and_login(provider)
    @user = create_from(provider)
    reset_session
    auto_login(@user)
  end
end
