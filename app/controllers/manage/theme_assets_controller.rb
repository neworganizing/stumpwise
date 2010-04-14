class Manage::ThemeAssetsController < ApplicationController
  layout 'manage'
  skip_before_filter :handle_invalid_site
  before_filter :require_administrator

  def create
    @theme_asset = Theme.find(params[:theme_id]).assets.create(params[:theme_asset])
    redirect_to :back
  end
  
  def destroy
    @theme_asset = ThemeAsset.first(:conditions => {:id => params[:id], :theme_id => params[:theme_id]})
    @theme_asset.destroy
  end
end