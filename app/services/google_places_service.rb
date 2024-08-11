require 'google_places'

class GooglePlacesService
  def initialize(api_key = ENV['GOOGLE_PLACES_API_KEY'])
    @client = GooglePlaces::Client.new(api_key)
  end

  def fetch_ramen_shop_details(place_id)
    result = @client.spot(place_id, language: 'ja')
    result
  end

  def search_ramen_shops(keyword, location, radius = 10000)
    combined_keyword = "#{keyword} ラーメン"
    results = @client.spots(location[:lat], location[:lng], radius: radius, types: ['restaurant'], keyword: combined_keyword, language: 'ja')
    filtered_results = results.select { |shop| shop.name.downcase.include?(keyword.downcase) }
    filtered_results
  end
end