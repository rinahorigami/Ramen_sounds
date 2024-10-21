class VideosController < ApplicationController
  before_action :set_video, only: %i[edit update destroy]

  def index
    @videos = Video.includes(:user).order(created_at: :desc)
  end

  def new
    @form = VideoSubmissionForm.new
  end

  def create
    @form = VideoSubmissionForm.new(video_submission_params, place_id: params[:place_id], current_user: current_user)

    if @form.save
      flash[:notice] = t('flash.videos.create_success')
      redirect_to videos_path
    else
      flash[:error] = t('flash.videos.create_failure')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @form = VideoSubmissionForm.new({}, current_user: current_user, video: @video)
  end

  def update
    @form = VideoSubmissionForm.new(video_submission_params, place_id: params[:place_id], current_user: current_user, video: @video)
  
    if @form.update(video_submission_params)
      flash[:notice] = t('flash.videos.update_success')
      redirect_to user_path(current_user)
    else
      flash[:error] = t('flash.videos.update_failure')
      render :edit
    end
  end  

  def destroy
    @video.destroy
    flash[:alert] = t('flash.videos.destroy_success')
    redirect_to user_path(current_user), status: :see_other
  end

  private

  def video_submission_params
    params.require(:video_submission_form).permit(:menu_name, :price, :comment, :file, :shop_name, :tag_list)
  end

  def set_video
    @video = Video.find(params[:id])
  end
end
