module Admin
  class VideosController < ApplicationController
    layout "admin"
    before_action :set_video, only: %i[show edit update destroy]

    def index
      @videos = Video.includes(:ramen_shop)
    end

    def show; end

    def edit
      @form = VideoSubmissionForm.new({}, current_user:, video: @video)
    end
  
    def update
      @form = VideoSubmissionForm.new(video_submission_params, place_id: params[:place_id], current_user:, video: @video)
    
      if @form.update(video_submission_params)
        flash[:notice] = t('flash.videos.update_success')
        redirect_to admin_video_path(@video)
      else
        flash[:error] = t('flash.videos.update_failure')
        render :edit
      end
    end  
  
    def destroy
      @video.destroy
      flash[:alert] = t('flash.videos.destroy_success')
      redirect_to admin_videos_path, status: :see_other
    end
  
    private
  
    def video_submission_params
      params.require(:video_submission_form).permit(:menu_name, :price, :comment, :file, :shop_name, :tag_list)
    end
  
    def set_video
      @video = Video.find(params[:id])
    end
  end
end
