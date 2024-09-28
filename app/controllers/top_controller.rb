class TopController < ApplicationController
  skip_before_action :require_login

  def index ;end

  def terms_of_service ;end

  def privacy ;end
end
