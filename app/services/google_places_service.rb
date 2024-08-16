class GooglePlacesService
  def initialize(api_key = ENV['GOOGLE_PLACES_API_KEY'])
    @client = GooglePlaces::Client.new(api_key)
  end

  def search_ramen_shops(keyword, location, radius = 10000)
    combined_keyword = "#{keyword} ラーメン"
    results = @client.spots(location[:lat], location[:lng], radius: radius, types: ['restaurant'], keyword: combined_keyword, language: 'ja')
    filtered_results = results.select { |shop| shop.name.downcase.include?(keyword.downcase) }
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