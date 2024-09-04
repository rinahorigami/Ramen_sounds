require 'google_places'

class GooglePlacesService
  def initialize(api_key)
    @client = GooglePlaces::Client.new(api_key)
  end

  # 店舗名で検索するメソッド
  def search_by_name(keyword, location, radius = 18000)
    combined_keyword = "#{keyword} ラーメン"
    results = @client.spots(location[:lat], location[:lng], radius: radius, types: ['restaurant'],keyword: combined_keyword, language: 'ja')
    filtered_results = results.select { |shop| shop.name.downcase.include?(keyword.downcase) }
    filtered_results
  end

  # 場所で検索するメソッド
  def search_by_location_with_spots(keyword, location, radius = 18000)
    combined_keyword = "#{keyword} ラーメン"
    results = @client.spots(location[:lat], location[:lng], radius: radius, types: ['restaurant'], keyword: combined_keyword, language: 'ja')
    filtered_results = results.select do |shop| 
      (shop.vicinity && shop.vicinity.include?(keyword)) || 
      (shop.formatted_address && shop.formatted_address.include?(keyword))
    end
    filtered_results
  end

  def get_ramen_shop_data(place_id)
    url = URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&key=#{@client.api_key}&language=ja")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)
    
    if data['status'] == 'OK'
      return data['result']
    else
      raise "Failed to fetch data: #{data['status']}"
    end
  end
end