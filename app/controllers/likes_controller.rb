class LikesController < ApplicationController
  before_action :set_video

  def create
    @like = @video.likes.create(user: current_user)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @video }
    end
  end

  def destroy
    @like = @video.likes.find_by(user: current_user)
    @like.destroy if @like
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @video }
    end
  end

  private

  def set_video
    @video = Video.find(params[:video_id])
  end
end
