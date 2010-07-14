class Admin::EventsController < ApplicationController
  before_filter :authenticate_admin!
  respond_to :html, :xml, :js
  layout 'admin'
  
  # GET /admin_events
  # GET /admin_events.xml
  def index
    if (params[:view] == "past")
      # show past events
      @view = "past"
      @events = Event.in_the_past.by_start_date_backward.paginate :page => params[:page]
    else
      # show upcoming events
      @view = "upcoming"
      @events = Event.in_the_future.by_start_date_forward.paginate :page => params[:page]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /admin/events/1
  # GET /admin/events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /admin/events/new
  # GET /admin/events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /admin/events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /admin_events
  # POST /admin_events.xml
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to(admin_event_path(@event), :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/events/1
  # PUT /admin/events/1.xml
  def update
    @event = Event.find(params[:id])
    params[:event][:publish_state] = params[:event][:publish_state].to_i
    
    respond_to do |format|
      if @event.update_attributes!(params[:event])
        format.html { redirect_to(admin_event_path(@event), :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/events/1
  # DELETE /admin/events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(admin_events_url) }
      format.xml  { head :ok }
    end
  end

  # POST /admin/events/ingest
  def ingest
    # TODO - move to model, hopefully rails will fix stupid mysqlcompat error!
    saved_events = []
    @parsed_file= FasterCSV.parse(params[:csv][:file], :headers => false, :skip_blanks => true) # parse=string, read=file!
    
    headers = @parsed_file.shift
    
    @parsed_file.each do |row|
      
        e = Event.new
        
        e.attributes.keys.each do |attribute|
          if attribute == 'start_date'
            date = row[headers.index(attribute)] if headers.index(attribute)
            e[attribute] = Time.parse(date) rescue Date.parse(date) rescue next if date
          else
            e[attribute] = row[headers.index(attribute)] if headers.index(attribute)
          end
        end
        
        org_name = row[headers.index('organiser_title')] if headers.index('organiser_title')
        if org_name
          o = Organisation.find_or_create_by_name(org_name)
          e.organisation = o
          o.description  = row[headers.index('org_desc')] if headers.index('org_desc')
          o.url          = row[headers.index('org_url')] if headers.index('org_url')
        end
        
        e.publish_state = params[:csv][:publish_state]
        
        saved_events << e if e.save
    end
    
    flash[:success], flash[:error] = nil # try to appease cuke :(
    if saved_events.length < 1
      flash[:error]="The CSV you uploaded was empty!"
    else
      flash[:success]="CSV import successful, #{saved_events.length} events ingested"
    end
      
    redirect_to admin_path
  end

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
  
  def bulk_publish
    # set published
    (params[:publish].keys).each do |event_id|
      Event.find(event_id.to_i).publish
    end
    
    # set draft
    (params[:event].keys - params[:publish].keys).each do |event_id|
      Event.find(event_id.to_i).hide
    end
    
    respond_to do |format|
      format.html { redirect_to(admin_events_path, :notice => "#{params[:event].length} publish states updated.") }
      format.js
      format.xml  { head :ok }
    end
  end
  
  protected
  
    # GET /admin/events/[hide|publish]
    # GET /admin/events/[hide|publish].xml
    def set_publish_state(pub_state)
      @event = Event.find(params[:id])

      respond_to do |format|
        if @event.update_attribute("publish_state", pub_state)
          format.html { redirect_to(admin_event_path(@event), :notice => 'Event was successfully updated.') }
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
