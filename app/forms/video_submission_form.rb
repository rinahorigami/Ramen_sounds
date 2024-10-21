class VideoSubmissionForm
  include ActiveModel::Model

  attr_accessor :menu_name, :price, :comment, :file, :shop_name, :tag_list, :current_user

  validates :file, presence: true, unless: -> { @video.file.present? }

  def initialize(attributes = {}, place_id: nil, current_user: nil, video: nil)
    super(attributes)
    @place_id = place_id
    @video = video || Video.new(user: current_user)
    @current_user = current_user
  end

  def tag_list_without_hash
    @video&.tag_list_without_hash
  end

  def save
    return false unless valid?
  
    ActiveRecord::Base.transaction do
      assign_video_attributes
      handle_ramen_shop
  
      if @video.save
        Rails.logger.debug "Video saved successfully: #{@video.inspect}"
        true
      else
        Rails.logger.error "Video save failed: #{@video.errors.full_messages.join(', ')}"
        false
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Transaction failed: #{e.record.errors.full_messages}"
    false
  end

  def update(attributes)
    self.attributes = attributes
    save
  end

  private

  def attributes=(attributes)
    attributes.each do |key, value|
      send("#{key}=", value) if respond_to?("#{key}=")
    end
  end

  def assign_video_attributes
    @video.menu_name = menu_name
    @video.price = price
    @video.comment = comment
    @video.file = file if file.present?
    @video.tag_list = tag_list if tag_list.present?
  end

  def handle_ramen_shop
    return unless @place_id.present?
  
    google_places_service = GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])
    ramen_shop_data = google_places_service.get_ramen_shop_data(@place_id)
    Rails.logger.debug "Fetched ramen shop data: #{ramen_shop_data.inspect}"
  
    ramen_shop = RamenShop.find_or_initialize_by(place_id: @place_id)
    ramen_shop.name = ramen_shop_data['name']
    ramen_shop.address = ramen_shop_data['formatted_address']
    ramen_shop.phone_number = ramen_shop_data['formatted_phone_number']
    ramen_shop.latitude = ramen_shop_data['geometry']['location']['lat']
    ramen_shop.longitude = ramen_shop_data['geometry']['location']['lng']
  
    ramen_shop.opening_hours = ramen_shop_data['opening_hours']['weekday_text'].join("\n") if ramen_shop_data['opening_hours'].present?
  
    ramen_shop.save!
    @video.ramen_shop = ramen_shop
    @video.place_id = @place_id
  end
end  
