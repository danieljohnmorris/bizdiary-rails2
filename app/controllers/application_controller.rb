class ApplicationController < ActionController::Base
  layout 'application'
  protect_from_forgery
  helper :all
  
  attr_reader :search_filter
  
  before_filter do |controller|
    @search_filter = SearchFilter.new(Event::EVENT_FILTER_SETUP, Event::EVENT_FILTER_KEY)
    @search_filter.load_filters(controller.params)
  end
end