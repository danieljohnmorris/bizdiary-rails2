class Admin::OrganisationsController < ApplicationController
  before_filter :authenticate_admin!
  layout 'admin'

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

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organisation }
    end
  end

  # GET /admin_organisations/new
  # GET /admin_organisations/new.xml
  def new
    @organisation = Organisation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organisation }
    end
  end

  # GET /admin_organisations/1/edit
  def edit
    @organisation = Organisation.find(params[:id])
  end

  # POST /admin_organisations
  # POST /admin_organisations.xml
  def create
    @organisation = Organisation.new(params[:organisation])

    respond_to do |format|
      if @organisation.save
        format.html { redirect_to(admin_organisation_path(@organisation), :notice => 'Organisation was successfully created.') }
        format.xml  { render :xml => @organisation, :status => :created, :location => @organisation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organisation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_organisations/1
  # PUT /admin_organisations/1.xml
  def update
    @organisation = Organisation.find(params[:id])

    respond_to do |format|
      if @organisation.update_attributes(params[:organisation])
        format.html { redirect_to(admin_organisation_path(@organisation), :notice => 'Organisation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organisation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_organisations/1
  # DELETE /admin_organisations/1.xml
  def destroy
    @organisation = Organisation.find(params[:id])
    @organisation.destroy

    respond_to do |format|
      format.html { redirect_to(admin_organisations_url) }
      format.xml  { head :ok }
    end
  end
end
