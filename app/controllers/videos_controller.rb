class VideosController < ApplicationController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    @video.user = current_user

    if @video.save
      redirect_to root_path, notice: '動画がアップロードされました。'
    else
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :file)
  end
end
