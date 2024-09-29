class CommentsController < ApplicationController
  before_action :find_video

  def create
    @comment = @video.comments.new(comment_params)
    @comment.user = current_user
  
    if @comment.save

    else
      flash[:error] = t('flash.comments.create_error')
      @videos = Video.includes(:user).order(created_at: :desc)
      render 'videos/index', status: :unprocessable_entity
    end
  end

  def destroy
    @comment = @video.comments.find(params[:id])
    @comment.destroy
    flash[:alert] = t('flash.comments.destroy_success')
    redirect_to videos_path, status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def find_video
    @video = Video.find(params[:video_id])
  end
end
