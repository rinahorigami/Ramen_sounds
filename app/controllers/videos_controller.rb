class VideosController < ApplicationController

  def index
    @videos = Video.includes(:user).order(created_at: :desc)
  end

  def new
    @video = Video.new
  end

  def create
    @video = current_user.videos.build(video_params)
    ramen_shop_id = params[:ramen_shop_id]
    
    if ramen_shop_id.present?
      google_places_service = GooglePlacesService.new
      ramen_shop_data = google_places_service.get_ramen_shop_data(ramen_shop_id)
      
      @ramen_shop = RamenShop.find_or_initialize_by(place_id: ramen_shop_id)
      @ramen_shop.name = ramen_shop_data['name']
      @ramen_shop.address = ramen_shop_data['formatted_address']
      @ramen_shop.phone_number = ramen_shop_data['formatted_phone_number']

      if ramen_shop_data['opening_hours'].present?
        @ramen_shop.opening_hours = ramen_shop_data['opening_hours']['weekday_text'].join("\n")
      end

      @ramen_shop.save
      @video.ramen_shop = @ramen_shop
    end

    if @video.save
      redirect_to videos_path, notice: '動画が投稿されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def video_params
    params.require(:video).permit(:menu_name, :price, :comment, :file)
  end
end
