class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def show
    @user = current_user
    @videos = @user.videos
    @liked_videos = @user.liked_videos
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "ユーザー登録に成功しました。"
      redirect_to login_path
    else
      flash[:error] = "ユーザー登録に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = 'プロフィールを編集しました。'
      redirect_to user_path(@user)
    else
      flash[:error] = 'プロフィール編集に失敗しました。'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end
