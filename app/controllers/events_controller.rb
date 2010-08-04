class EventsController < ApplicationController
  
  include EventsHelper
  
  before_filter :authenticate_person!, :only => [:starred, :star, :unstar]
  before_filter :authenticate_organisation!, :only => [:new, :create, :edit, :update, :destroy]
    
  def filter
    [:topic, :type, :industry].each do |tag| 
      params.delete(tag) if params[tag].blank?
    end

    #return render :text => [params, SearchFilter.filter_index[:event_filter].prepare_filters(params), AppConfig.event_filters].inspect
    @events = Event.filtered(params, current_person || nil).paginate :page => params[:page]
  end
  
  # GET /events/search
  def search
    @q = params[:q]
    
    if @q.blank?
      redirect_to root_path
      return
    end
        
    @events = Event.search(@q)
    render "events/filter"
  end
  
  def index
    redirect_to root_path
  end
  
  ###### REST CRUD CONTROLLER METHODS
  
  # # GET /events
  # # GET /events.xml
  # def index
  #   if (params[:view] == "past")
  #     # show past events
  #     @view = "past"
  #     @events = Event.with_relations.in_the_past.by_start_date_backward.paginate :page => params[:page]
  #   else
  #     # show upcoming events
  #     @view = "upcoming"
  #     @events = Event.with_relations.in_the_future.by_start_date_forward.paginate :page => params[:page]
  #   end
  # 
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @events }
  #   end
  # end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @organisation = Organisation.find(params[:organisation_id])
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @organisation = Organisation.find(params[:organisation_id])
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    @event.organisation = Organisation.find(params[:organisation_id])
    
    respond_to do |format|
      if @event.save
        format.html { redirect_to(event_path(@event), :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    raise "YO".inspect
    @event = Event.find(params[:id])
    @event.organisation = Organisation.find(params[:organisation_id])
    
    respond_to do |format|
      if @event.update_attributes!(params[:event])
        format.html { redirect_to(event_path(@event), :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
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
  
  #### PUBLISHING & HIDING
  
  public
    
  # GET /admin/events/hide
  # GET /admin/events/hide.xml
  # GET /admin/events/hide.js
  def hide
    set_publish_state(Event::DRAFT_STATE)
  end

  # GET /admin/events/publish
  # GET /admin/events/publish.xml
  # GET /admin/events/publish.js
  def publish
    set_publish_state(Event::PUBLISHED_STATE)
  end

  protected

    # GET /admin/events/[hide|publish]
    # GET /admin/events/[hide|publish].xml
    def set_publish_state(pub_state)
      @organisation = Organisation.find(params[:organisation_id])
      @event = Event.find(params[:id])

      respond_to do |format|
        if @event.update_attribute("publish_state", pub_state)
          format.html { redirect_to(event_path(@event), :notice => 'Event was successfully updated.') }
          format.js
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.js
          format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
        end
      end
    end  
end
