class RamenShopsController < ApplicationController
  def index
    search_type = params[:search_type] # 'name', 'location', or 'tag'
    query = params[:query]
    location_param = params[:location]
    radius = 5000 # 例: 5km

    location = if location_param.present?
                 lat, lng = location_param.split(',').map(&:to_f)
                 { lat: lat, lng: lng }
               else
                 { lat: 35.6895, lng: 139.6917 } # デフォルトは東京
               end

    google_places_service = GooglePlacesService.new

    case search_type
    when 'name'
      @results = google_places_service.search_ramen_shops_by_keyword(query, location, radius)
    when 'location'
      @results = google_places_service.search_ramen_shops_by_location(location, radius)
    when 'tag'
      @results = query.present? ? Video.by_tag(query) : []
    else
      @results = []
    end

    @ramen_shops = Kaminari.paginate_array(@results).page(params[:page]).per(10)
  end

  def show
    @ramen_shop = RamenShop.find_by(id: params[:id])
  
    if @ramen_shop
      @videos = Video.where(ramen_shop_id: @ramen_shop.id)
    else
      google_places_service = GooglePlacesService.new
      @ramen_shop_data = google_places_service.get_ramen_shop_data(params[:id])
  
      if @ramen_shop_data
        place_id = @ramen_shop_data['place_id']
        @videos = Video.where(place_id: place_id)
      else
        @videos = []
      end
    end
  end
end
