require 'google_maps_service'

class GooglePlacesService
  def initialize(api_key = ENV['GOOGLE_PLACES_API_KEY'])
    @client = GoogleMapsService::Client.new(key: api_key)
  end

  def search_ramen_shops_by_keyword(keyword, location, radius = 1000)
    combined_keyword = "#{keyword} ラーメン"
    @client.nearby_search(
      location: [location[:lat], location[:lng]],
      radius: radius,
      keyword: combined_keyword,
      language: 'ja'
    )
  end

  def search_ramen_shops_by_location(location, radius = 1000)
    @client.nearby_search(
      location: [location[:lat], location[:lng]],
      radius: radius,
      type: 'restaurant',
      language: 'ja'
    )
  end

  def get_ramen_shop_data(place_id)
    @client.place_details(place_id, language: 'ja')
  end
end