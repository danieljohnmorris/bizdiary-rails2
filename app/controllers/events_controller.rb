class EventsController < ApplicationController
  
  include EventsHelper
  
  before_filter :authenticate_person!, :only => [:starred, :star, :unsta]
  
  def index
    redirect_to root_path
  end
  
  def filter
    @events = Event.filtered(prepare_filters(params, {:organisation => :id, :topic => :text, :type => :text, :industry => :text}), current_person || nil).paginate :page => params[:page]
    render :template => 'home/index'
  end
  
  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end
  
  # GET /events/search
  def search
    @q = params[:q]
    
    if @q.blank?
      redirect_to root_path
      return
    end
        
    @events = Event.search(@q)
    render "home/index"
  end
  
  ###### STARRING CONTROLLER METHODS

  # GET /events/starred
  # GET /events/starred.xml
  def starred
    @person = current_person
    
    #@starred_events = Event.starred(current_person)
    #...NEEDS TO USE PAGINATE LIKE...
    #@starred_events = Event.paginate :page => params[:page], :order => 'start_date ASC', :conditions => ["publish_state = #{Event::PUBLISHED_STATE}", 'start_date > NOW()']
    @starred_events = Event.starred(current_person).paginate(:page => params[:page] || 1, :per_page => 25)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @starred_events }
    end
  end

  # GET /events/star
  # GET /vents/star.xml
  def star
    set_starred_state(true)
  end

  # GET /events/unstar
  # GET /events/unstar.xml
  def unstar
    set_starred_state(false)
  end
  
  protected
  
    # GET /events/[star|unstar]
    # GET /events/[star|unstar].xml
    def set_starred_state(intended_starred_state)
      @event = Event.find(params[:id])
      
      case intended_starred_state
        when true
          message = "Event successfully starred"
          starred_state = @event.star(current_person)
          problem = false
        when false
          message = "Event successfully unstarred"
          starred_state = @event.unstar(current_person)
          problem = false
      end

      respond_to do |format|
        unless problem
          format.html { redirect_to(event_path(@event), :notice => message) }
          format.js
          format.xml  { head :ok }
        else
          format.html { render :action => "show" }
          format.js
          format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
        end
      end
    end
end
