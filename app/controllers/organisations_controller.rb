class OrganisationsController < ApplicationController
  before_filter :authenticate_organisation!, :except => [:index, :show]

  # GET /admin_organisations
  # GET /admin_organisations.xml
  def index
    @organisations = Organisation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organisations }
    end
  end

  # GET /admin_organisations/1
  # GET /admin_organisations/1.xml
  def show
    @organisation = Organisation.find(params[:id])
    
    if organisation_signed_in?
      @events = @organisation.events
    else
      @events = @organisation.events.published.by_start_date_forward
    end
    @events = @events.paginate :page => params[:page]
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organisation }
    end
  end
end
