class LikesController < ApplicationController
  before_action :set_video

  def create
    @like = @video.likes.create(user: current_user)
  end

  def destroy
    @like = @video.likes.find_by(user: current_user)
    @like.destroy if @like
  end

  private

  def set_video
    @video = Video.find(params[:video_id])
  end
end
