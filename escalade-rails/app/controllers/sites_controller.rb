class SitesController < ApplicationController
  before_action :authenticate_user!

  def index
    @sites = current_user.sites
  end

  def show
    @site = current_user.sites.find(params[:id])
  end
end
