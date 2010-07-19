class HomeController < ApplicationController
  def index
    @events = Event.published.in_the_future.by_start_date_forward

    @events = @events.tagged_with(params[:topic], :context => :topic) if (params[:topic])
    @events = @events.tagged_with(params[:topic], :context => :topic) if (params[:type])
    @events = @events.tagged_with(params[:topic], :context => :topic) if (params[:industry])
    @events = @events.find_all_by_organiser(Organisation.find(params[:organiser])) if (params[:organiser])

    @events = @events.paginate :page => params[:page]
    
    @list_type = params[:list] || "grid"
    @list_type += "/" unless @list_type.blank?
  end
end
