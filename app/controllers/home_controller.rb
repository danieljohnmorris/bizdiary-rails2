class HomeController < ApplicationController
  def index
    @events = Event.published.in_the_future.by_start_date_forward
    @events = @events.paginate :page => params[:page]
  end
end
