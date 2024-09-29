class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new ;end

  def create
    @user = User.find_by(email: params[:email])

    if @user
      @user.deliver_reset_password_instructions!
      flash[:notice] = t('flash.password_resets.create_success')
      redirect_to login_path
    else
      flash[:notice] = t('flash.password_resets.create_success')
      redirect_to login_path
    end
  end

  def edit
    @user = User.load_from_reset_password_token(params[:id])
    return not_authenticated if @user.blank?
  end

  def update
    @user = User.load_from_reset_password_token(params[:id])
    return not_authenticated if @user.blank?

    if @user.update(user_params)
      flash[:notice] = t('flash.password_resets.update_success')
      redirect_to login_path
    else
      Rails.logger.info @user.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
