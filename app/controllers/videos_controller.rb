class VideosController < ApplicationController

  def index
    @videos = Video.includes(:user).order(created_at: :desc)
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    @video.user = current_user

    if @video.save
      redirect_to videos_path, notice: '動画がアップロードされました。'
    else
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :file)
  end
end
