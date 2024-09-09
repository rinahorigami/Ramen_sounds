class RamenShopsController < ApplicationController
  def index
    @latitude = params[:lat].to_f if params[:lat].present?
    @longitude = params[:lng].to_f if params[:lng].present?

    @video = current_user.videos.find_by(id: params[:video_id])
  
    if params[:lat].present? && params[:lng].present?
      location = { lat: params[:lat].to_f, lng: params[:lng].to_f }  # ユーザーの現在地
    else
      location = { lat: 35.6895, lng: 139.6917 }  # デフォルトの位置（東京）
    end
  
    google_places_service = GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])
  
    if params[:keyword].present?
      case params[:search_type]
      when 'name'
        # 店舗名で検索
        ramen_shops_array = google_places_service.search_by_name(params[:keyword], location)
      when 'location'
        # 場所で検索
        ramen_shops_array = google_places_service.search_by_location_with_spots(params[:keyword], location)
      when 'tag'
        # タグで検索
        ramen_shops_array = Video.by_tag(params[:keyword])
      else
        ramen_shops_array = []
      end
    else
      ramen_shops_array = []
    end
  
    @ramen_shops = Kaminari.paginate_array(ramen_shops_array).page(params[:page]).per(10)
  end

  def show
    @ramen_shop = RamenShop.find_by(id: params[:id])
  
    if @ramen_shop
      @videos = Video.where(ramen_shop_id: @ramen_shop.id)
    else
      google_places_service = GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])
      @ramen_shop_data = google_places_service.get_ramen_shop_data(params[:id])
  
      if @ramen_shop_data
        place_id = @ramen_shop_data['place_id']
        @videos = Video.where(place_id: place_id)
      else
        @videos = []
      end
    end

    if params[:from_video_form] == "edit".present?
      @video = current_user.videos.find_by(id: params[:video_id]) # ここでビデオを取得
    end
  end

  def map
    @ramen_shop = RamenShop.find_by(place_id: params[:id])
  
    if @ramen_shop.nil?
      google_places_service = GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])
      @ramen_shop_data = google_places_service.get_ramen_shop_data(params[:id])
  
      if @ramen_shop_data.nil?
        render plain: "Ramen shop not found", status: :not_found
      end
    end

    @link_url = if @ramen_shop.present?
      ramen_shop_path(id: @ramen_shop.place_id)
    elsif @ramen_shop_data.present?
      ramen_shop_path(id: @ramen_shop_data['place_id'])
    else
      '#'
    end
  end
end
