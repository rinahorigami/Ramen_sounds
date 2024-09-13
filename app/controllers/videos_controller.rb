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
    ramen_shop_id = params[:ramen_shop_id]
    
    if ramen_shop_id.present?
      google_places_service = GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])
      ramen_shop_data = google_places_service.get_ramen_shop_data(ramen_shop_id)
      
      @ramen_shop = RamenShop.find_or_initialize_by(place_id: ramen_shop_id)
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
          @video.place_id = ramen_shop_id

        if @video.save
          flash[:notice] = "動画が投稿されました。"
          redirect_to videos_path
        else
          flash[:error] = "動画投稿に失敗しました。"
          render :new, status: :unprocessable_entity
        end
      else
        flash[:error] = "ラーメン店情報の保存に失敗しました。"
        render :new, status: :unprocessable_entity
      end

    else
      @video.ramen_shop = nil
      @video.place_id = nil

      if @video.save
        flash[:notice] = "動画が投稿されました。"
        redirect_to videos_path
      else
        flash[:error] = "動画投稿に失敗しました。"
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit ;end

  def update
    ramen_shop_id = params[:ramen_shop_id]
  
    if ramen_shop_id.present?
      google_places_service = GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])
      ramen_shop_data = google_places_service.get_ramen_shop_data(ramen_shop_id)
  
      @ramen_shop = RamenShop.find_or_initialize_by(place_id: ramen_shop_id)
      @ramen_shop.name = ramen_shop_data['name']
      @ramen_shop.address = ramen_shop_data['formatted_address']
      @ramen_shop.phone_number = ramen_shop_data['formatted_phone_number']
      @ramen_shop.latitude = ramen_shop_data['geometry']['location']['lat']
      @ramen_shop.longitude = ramen_shop_data['geometry']['location']['lng']
  
      if ramen_shop_data['opening_hours'].present?
        @ramen_shop.opening_hours = ramen_shop_data['opening_hours']['weekday_text'].join("\n")
      end
  
      @ramen_shop.save
      @video.ramen_shop = @ramen_shop
      @video.place_id = ramen_shop_id
    else
      @video.ramen_shop = nil
      @video.place_id = nil
    end
  
    if @video.update(video_params)
      flash[:notice] = "動画を編集しました。"
      redirect_to videos_path
    else
      flash[:error] = '動画の編集に失敗しました。'
      render :edit
    end
  end

  def destroy
    @video.destroy
    flash[:alert] = '動画が削除されました。'
    redirect_to videos_path, status: :see_other
  end

  private

  def video_params
    params.require(:video).permit(:menu_name, :price, :comment, :file, :tag_list)
  end

  def set_video
    @video = current_user.videos.find(params[:id])
  end
end
