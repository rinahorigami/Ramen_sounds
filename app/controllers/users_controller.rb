class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def show
    @user = current_user
    @videos = @user.videos.includes(:user, :ramen_shop).order(created_at: :desc)
    @liked_videos = @user.liked_videos.includes(:user, :ramen_shop).order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = t('flash.users.create_success')
      redirect_to login_path
    else
      flash[:error] = t('flash.users.create_failure')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = t('flash.users.update_success')
      redirect_to user_path(@user)
    else
      flash[:error] = t('flash.users.update_failure')
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end
