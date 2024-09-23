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

  def search_by_location(keyword)
    # 場所名で検索するために `spots_by_query` を使用
    results = @client.spots_by_query(keyword, language: 'ja')
  
    # 必要な場所情報のみ返す（駅名などの場所名）
    filtered_results = results.map do |place|
      {
        name: place.name,
        place_id: place.place_id,
        location: {
          lat: place.lat,
          lng: place.lng
        }
      }
    end
  
    filtered_results
  end

  def get_ramen_shop_data(place_id)
    url = URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&key=#{@client.api_key}&language=ja")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    Rails.logger.debug "Google Places API Response: #{data.inspect}"
    
    if data['status'] == 'OK'
      return data['result']
    else
      raise "Failed to fetch data: #{data['status']}"
    end
  end
end