class RamenShopsController < ApplicationController
  def index
    if params[:keyword].present?
      google_places_service = GooglePlacesService.new
      @ramen_shops = google_places_service.search_ramen_shops(params[:keyword], { lat: 35.6895, lng: 139.6917 }) # 位置情報を東京に設定
    else
      @ramen_shops = []
    end
  end
end
