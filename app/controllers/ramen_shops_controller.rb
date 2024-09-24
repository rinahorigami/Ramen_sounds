class RamenShopsController < ApplicationController
  def index
    @latitude = params[:lat].to_f if params[:lat].present?
    @longitude = params[:lng].to_f if params[:lng].present?
  
    @video = current_user.videos.find_by(id: params[:video_id])
  
    if params[:lat].present? && params[:lng].present?
      location = { lat: params[:lat].to_f, lng: params[:lng].to_f }
    else
      location = { lat: 35.6895, lng: 139.6917 }
    end
  
    if params[:keyword].present?
      case params[:search_type]
      when 'name'
        ramen_shops_array = RamenShop.where('name LIKE ?', "%#{params[:keyword]}%")
      when 'location'
        google_places_service = GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])
        ramen_shops_array = google_places_service.search_by_location(params[:keyword])
      when 'tag'
        ramen_shops_array = Video.by_tag(params[:keyword]).map(&:ramen_shop).compact
      else
        ramen_shops_array = []
      end
    else
      ramen_shops_array = []
    end
  
    # ramen_shops_array が nil の場合、空配列を設定
    ramen_shops_array ||= []
  
    @ramen_shops = Kaminari.paginate_array(ramen_shops_array).page(params[:page]).per(10)
  end  

  def show
    @latitude = params[:lat]
    @longitude = params[:lng]
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
      @video = current_user.videos.find_by(id: params[:video_id])
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

  def autocomplete
    search_type = params[:search_type]
    keyword = params[:keyword]
  
    results = case search_type
              when 'name'
                RamenShop.where('name LIKE ?', "%#{keyword}%").limit(10)
              when 'location'
                google_places_service = GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])
                google_places_service.search_by_location(keyword)
              when 'tag'
                Tag.where('name LIKE ?', "%#{keyword}%").limit(10)
              else
                []
              end
  
    render json: results.map { |result| { name: result[:name], place_id: result[:place_id] } }
  end
end
