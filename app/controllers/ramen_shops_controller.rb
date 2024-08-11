class RamenShopsController < ApplicationController
  def index
    if params[:keyword].present?
      location = { lat: 35.6895, lng: 139.6917 }
      google_places_service = GooglePlacesService.new
      @ramen_shops = google_places_service.search_ramen_shops(params[:keyword], location)
    else
      @ramen_shops = []
    end
  end

  def show
    google_places_service = GooglePlacesService.new
    @ramen_shop = google_places_service.fetch_ramen_shop_details(params[:id])
  end
end
