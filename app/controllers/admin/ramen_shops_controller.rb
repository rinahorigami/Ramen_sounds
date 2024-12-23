module Admin
  class RamenShopsController < ApplicationController
    layout "admin"
    before_action :set_shop, only: %i[show edit update destroy]

    require 'rake'

    def index
      @ramen_shops = RamenShop.includes(:videos)
    end

    def new
      @ramen_shop = RamenShop.new
    end
    
    def create
      begin
        # フォームデータを取得
        shop_name = params[:shop_name] || 'ラーメン'
        shop_lat = params[:shop_lat] || '35.6895'
        shop_lng = params[:shop_lng] || '139.6917'
  
        # Rakeタスクに渡す環境変数を設定
        ENV['SHOP_NAME'] = shop_name
        ENV['SHOP_LAT'] = shop_lat
        ENV['SHOP_LNG'] = shop_lng
  
        # Rakeタスクを実行
        Rake::Task.clear
        Rails.application.load_tasks
        Rake::Task['update_ramen_shops:fetch_data_by_name'].invoke
  
        flash[:notice] = "RamenShopsの更新が成功しました。"
      rescue StandardError => e
        flash[:alert] = "エラーが発生しました: #{e.message}"
      ensure
        Rake::Task['update_ramen_shops:fetch_data_by_name'].reenable
      end
  
      redirect_to admin_ramen_shops_path
    end

    def show 
      @ramen_shop = RamenShop.find(params[:id])
      @videos = @ramen_shop.videos.order(created_at: :desc)
    end

    def edit; end

    def update
      if @ramen_shop.update(shop_params)
        flash[:notice] = "ラーメン店の情報を更新しました。"
        redirect_to admin_ramen_shop_path(@ramen_shop)
      else
        flash[:alert] = "更新に失敗しました。"
        render :edit
      end
    end

    def destroy
      @ramen_shop.destroy
      flash[:alert] = "ラーメン店を削除しました。"
      redirect_to admin_ramen_shops_path, status: :see_other
    end

    private

    def set_shop
      @ramen_shop = RamenShop.find(params[:id])
    end

    def shop_params
      params.require(:ramen_shop).permit(:place_id, :name, :address, :phone_number, :opening_hours)
    end
  end
end
