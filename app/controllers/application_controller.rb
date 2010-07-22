class ApplicationController < ActionController::Base
  layout 'application'
  protect_from_forgery
  helper :all
  
  def assign_list_type
    @list_type = ["grid", "inline"].include?(params[:list]) ? params[:list] : "grid"
    @list_type += "/" unless @list_type.blank?
  end
end
