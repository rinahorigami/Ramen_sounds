namespace :update_ramen_shops do
  desc "ラーメン店情報をRamenShopsテーブルに保存"
  task fetch_data_by_name: :environment do
    name = ENV['SHOP_NAME'] || 'ラーメン'

    service = GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])

    # 店舗名で検索
    ramen_shops = service.search_by_name(name)
    puts "Number of shops found: #{ramen_shops.size}"

    ramen_shops.each do |shop_data|
      # shop_data の中身を確認するために出力
      puts "Shop data: #{shop_data.inspect}"

      # save_ramen_shop_data メソッドを使用してRamenShopを保存
      begin
        ramen_shop = service.save_ramen_shop_data(shop_data['place_id'])

        if ramen_shop.persisted?
          puts "Saved or found existing ramen shop: #{ramen_shop.name}"
        else
          puts "Failed to save ramen shop: #{ramen_shop.errors.full_messages.join(', ')}"
        end
      rescue => e
        puts "Error saving ramen shop: #{e.message}"
      end
    end

    puts "Finished updating ramen shops data."
  end
end