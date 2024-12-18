module Admin
  class UsersController < ApplicationController
    layout "admin"

    def index
      @users = User.all
    end

    def show
      @user = User.find(params[:id])
    end
  end
end
