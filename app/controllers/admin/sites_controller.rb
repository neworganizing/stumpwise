class Admin::SitesController < ApplicationController
  before_filter :require_authorized_user, :require_acceptance_of_campaign_agreement

  def edit
    @site = current_site
  end
  
  def update
    @site = current_site
    if @site.update_attributes(params[:site])
      flash[:notice] = t("site.update.success")
      redirect_to edit_admin_site_path
    else
      flash.now[:error] = t("site.update.fail")
      render :action => 'edit'
    end
  end
end
