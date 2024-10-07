class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password], params[:remember_me])

    if @user
      flash[:notice] = t('flash.sessions.login_success')
      redirect_to videos_path
    else
      flash[:error] = t('flash.sessions.login_failure')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:notice] = t('flash.sessions.logout')
    redirect_to root_path, status: :see_other
  end
end
