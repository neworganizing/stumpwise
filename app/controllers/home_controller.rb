class HomeController < ApplicationController
  layout 'marketing'
  
  def index
    redirect_to "http://get.stumpwise.com"
  end
  
  def home
  end
  
  def signup
    @site = Site.new
    @user = User.new
  end
  
  def setup
    flash.now[:error] = "I'm sorry, that's not a valid invite code."
    render :action => 'signup'
  end
end