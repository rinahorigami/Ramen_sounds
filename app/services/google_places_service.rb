require 'google_places'

class GooglePlacesService
  def initialize(api_key)
    @client = GooglePlaces::Client.new(api_key)
  end

  def save_ramen_shop_data(ramen_shop_id)
    ramen_shop_data = get_ramen_shop_data(ramen_shop_id)

    ramen_shop = RamenShop.find_or_initialize_by(place_id: ramen_shop_id)
    ramen_shop.name = ramen_shop_data['name']
    ramen_shop.address = ramen_shop_data['formatted_address']
    ramen_shop.phone_number = ramen_shop_data['formatted_phone_number']
    ramen_shop.latitude = ramen_shop_data['geometry']['location']['lat']
    ramen_shop.longitude = ramen_shop_data['geometry']['location']['lng']

    if ramen_shop_data['opening_hours'].present?
      ramen_shop.opening_hours = ramen_shop_data['opening_hours']['weekday_text'].join("\n")
    end
  
    # 変更がある場合のみ保存
    if ramen_shop.changed?
      if ramen_shop.save
        return ramen_shop
      else
        raise "Failed to save ramen shop data"
      end
    else
      puts "No changes detected, skipping save for #{ramen_shop.name}"
      return ramen_shop
    end
  end

  def search_by_name(name)
    endpoint = "https://maps.googleapis.com/maps/api/place/textsearch/json"
    params = {
      query: name,
      location: '33.5904,130.4017',  # 福岡の位置
      radius: 5000,  # 半径5kmの範囲
      language: 'ja',
      key: ENV['GOOGLE_PLACES_API_KEY']
    }
  
    # Google Places APIにリクエストを送信
    response = HTTParty.get(endpoint, query: params)
    
    # レスポンスをログに出力
    puts "API response: #{response.inspect}"
  
    # レスポンスが成功したかを確認
    if response.success?
      response.parsed_response['results']
    else
      puts "API request failed with status: #{response.code}, message: #{response.message}"
      []
    end
  end  

  def search_by_location_with_spots(keyword, location, radius = 18000)
    combined_keyword = "#{keyword} ラーメン"
    results = @client.spots(location[:lat], location[:lng], radius: radius, types: ['restaurant'], keyword: combined_keyword, language: 'ja')
    filtered_results = results.select do |shop| 
      (shop.vicinity && shop.vicinity.include?(keyword)) || 
      (shop.formatted_address && shop.formatted_address.include?(keyword))
    end
  
    # 検索結果の中身を確認するために出力
    filtered_results.each do |shop_data|
      puts "Shop data: #{shop_data.inspect}"
    end
  
    filtered_results
  end

  def search_by_location(keyword)
    # 場所名で検索し、typesを指定して地名や地域に限定する
    results = @client.spots_by_query(keyword, language: 'ja', types: ['locality', 'sublocality', 'administrative_area_level_1', 'administrative_area_level_2', 'administrative_area_level_3', 'administrative_area_level_4', 'colloquial_area', 'postal_code', 'country'])
  
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