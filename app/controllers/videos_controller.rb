class VideosController < ApplicationController
  before_action :set_video, only: %i[edit update destroy]

  def index
    @videos = Video.includes(:user).order(created_at: :desc)
  end

  def new
    @video = Video.new
  end

  def create
    @video = current_user.videos.build(video_params)
    place_id = params[:place_id]
    
    if place_id.present?
      google_places_service = GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])
      ramen_shop_data = google_places_service.get_ramen_shop_data(place_id)
   
      @ramen_shop = RamenShop.find_or_initialize_by(place_id: place_id)
      @ramen_shop.name = ramen_shop_data['name']
      @ramen_shop.address = ramen_shop_data['formatted_address']
      @ramen_shop.phone_number = ramen_shop_data['formatted_phone_number']
      @ramen_shop.latitude = ramen_shop_data['geometry']['location']['lat']
      @ramen_shop.longitude = ramen_shop_data['geometry']['location']['lng']
   
      if ramen_shop_data['opening_hours'].present?
        @ramen_shop.opening_hours = ramen_shop_data['opening_hours']['weekday_text'].join("\n")
      end
   
      if @ramen_shop.save
        @video.ramen_shop = @ramen_shop
        @video.place_id = place_id
      else
        flash[:error] = t('flash.videos.ramen_shop_save_failure')
        render :new, status: :unprocessable_entity
        return
      end
    else
      @video.ramen_shop = nil
      @video.place_id = nil
    end
   
    if @video.save
      flash[:notice] = t('flash.videos.create_success')
      redirect_to videos_path
    else
      flash[:error] = t('flash.videos.create_failure')
      render :new, status: :unprocessable_entity
    end
  end   

  def edit ;end

  def update
    place_id = params[:place_id]
  
    if place_id.present?
      google_places_service = GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])
      ramen_shop_data = google_places_service.get_ramen_shop_data(place_id)
  
      @ramen_shop = RamenShop.find_or_initialize_by(place_id: place_id)
      @ramen_shop.name = ramen_shop_data['name']
      @ramen_shop.address = ramen_shop_data['formatted_address']
      @ramen_shop.phone_number = ramen_shop_data['formatted_phone_number']
      @ramen_shop.latitude = ramen_shop_data['geometry']['location']['lat']
      @ramen_shop.longitude = ramen_shop_data['geometry']['location']['lng']
  
      if ramen_shop_data['opening_hours'].present?
        @ramen_shop.opening_hours = ramen_shop_data['opening_hours']['weekday_text'].join("\n")
      end
  
      unless @ramen_shop.save
        Rails.logger.debug "Failed to save RamenShop: #{@ramen_shop.errors.full_messages}"
        flash[:error] = t('flash.videos.ramen_shop_save_failure')
        render :edit
        return
      end
  
      @video.ramen_shop = @ramen_shop
      @video.place_id = place_id
    else
      @video.ramen_shop = nil
      @video.place_id = nil
    end
  
    if @video.update(video_params)
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

  def video_params
    params.require(:video).permit(:menu_name, :price, :comment, :file, :tag_list)
  end

  def set_video
    @video = Video.find(params[:id])
  end
end
