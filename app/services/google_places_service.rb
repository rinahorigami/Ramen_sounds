require 'google_places'

class GooglePlacesService
  def initialize(api_key)
    @client = GooglePlaces::Client.new(api_key)
  end

  # 店舗名で検索するメソッド
  def search_by_name(keyword, location, radius = 18000)
    results = @client.spots(location[:lat], location[:lng], radius: radius, types: ['restaurant'], keyword: keyword, language: 'ja')
    filtered_results = results.select { |shop| shop.name.downcase.include?(keyword.downcase) }
    filtered_results
  end

  # 場所で検索するメソッド
  def search_by_location_with_spots(keyword, location, radius = 18000)
    results = @client.spots(location[:lat], location[:lng], radius: radius, types: ['restaurant'], keyword: keyword, language: 'ja')
    filtered_results = results.select do |shop| 
      (shop.vicinity && shop.vicinity.include?(keyword)) || 
      (shop.formatted_address && shop.formatted_address.include?(keyword))
    end
    filtered_results
  end

  # 地名から緯度経度を取得するメソッド
  def geocode_location_name(location_name)
    results = @google_maps_client.geocode(location_name)
    if results.any?
      results.first[:geometry][:location]
    else
      nil
    end
  end

  # 地名で検索するメソッド
  def search_ramen_shops_by_location_name(location_name, radius = 18000)
    coordinates = geocode_location_name(location_name)
    if coordinates
      @google_maps_client.nearby_search(
        location: [coordinates[:lat], coordinates[:lng]],
        radius: radius,
        keyword: 'ラーメン',
        type: 'restaurant'
      )
    else
      []
    end
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