class RamenShopsController < ApplicationController
  def index
    if params[:keyword].present?
      location = { lat: 35.6895, lng: 139.6917 }
      google_places_service = GooglePlacesService.new
      ramen_shops_array = google_places_service.search_ramen_shops(params[:keyword], location)
      @ramen_shops = Kaminari.paginate_array(ramen_shops_array).page(params[:page]).per(10)
    else
      @ramen_shops = Kaminari.paginate_array([]).page(params[:page]).per(10)
    end
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
