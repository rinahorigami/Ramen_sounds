class RamenShopsController < ApplicationController
  def index
    if params[:keyword].present?
      location = { lat: 35.6895, lng: 139.6917 }
      google_places_service = GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])
  
      case params[:search_type]
      when 'name'
        # 店舗名で検索
        ramen_shops_array = google_places_service.search_by_name(params[:keyword], location)
      when 'location'
        # 場所で検索 (例: 特定のエリアを含む場合)
        ramen_shops_array = google_places_service.search_by_location_with_spots(params[:keyword], location)
      when 'tag'
        # タグで検索 (Videoモデルを使用して検索)
        ramen_shops_array = Video.by_tag(params[:keyword])
      else
        # デフォルトは空の結果
        ramen_shops_array = []
      end
  
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
      google_places_service = GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])
      @ramen_shop_data = google_places_service.get_ramen_shop_data(params[:id])
  
      if @ramen_shop_data
        place_id = @ramen_shop_data['place_id']
        @videos = Video.where(place_id: place_id)
      else
        @videos = []
      end
    end
  end

  def map
    @ramen_shop = RamenShop.find_by(place_id: params[:id])
  
    if @ramen_shop.nil?
      # RamenShop がデータベースにない場合、Google Places API を使ってデータを取得することもできます
      google_places_service = GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])
      @ramen_shop_data = google_places_service.get_ramen_shop_data(params[:id])
  
      # 取得したデータを元にビューを表示するか、必要に応じて処理を行います
      if @ramen_shop_data.nil?
        # データが見つからない場合の処理（例: エラーメッセージを表示する）
        render plain: "Ramen shop not found", status: :not_found
      end
    end

    @link_url = if @ramen_shop.present?
      ramen_shop_path(@ramen_shop)
    elsif @ramen_shop_data.present?
      ramen_shop_path(id: @ramen_shop_data['place_id'])
    else
      '#'
    end
  end
end
