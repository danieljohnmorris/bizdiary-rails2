class OrganisationsController < ApplicationController
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

  ###### STARRING CONTROLLER METHODS

  # GET /organisations/starred
  # GET /organisations/starred.xml
  def starred
   @person = current_person

   #@starred_organisations = Organisation.starred(current_person)
   #...NEEDS TO USE PAGINATE LIKE...
   #@starred_organisations = Organisation.paginate :page => params[:page], :order => 'start_date ASC', :conditions => ["publish_state = #{Organisation::PUBLISHED_STATE}", 'start_date > NOW()']
   @starred_organisations = Organisation.starred(current_person).paginate(:page => params[:page] || 1, :per_page => 25)

   respond_to do |format|
     format.html # index.html.erb
     format.xml  { render :xml => @starred_organisations }
   end
 end

 # GET /organisations/star
 # GET /vents/star.xml
 def star
   set_starred_state(true)
 end

 # GET /organisations/unstar
 # GET /organisations/unstar.xml
 def unstar
   set_starred_state(false)
 end

 protected

   # GET /organisations/[star|unstar]
   # GET /organisations/[star|unstar].xml
   def set_starred_state(intended_starred_state)
     @organisation = Organisation.find(params[:id])

     case intended_starred_state
       when true
         message = "Organisation successfully starred"
         starred_state = @organisation.star(current_person)
         problem = false
       when false
         message = "Organisation successfully unstarred"
         starred_state = @organisation.unstar(current_person)
         problem = false
     end

     respond_to do |format|
       unless problem
         format.html { redirect_to(organisation_path(@organisation), :notice => message) }
         format.js
         format.xml  { head :ok }
       else
         format.html { render :action => "show" }
         format.js
         format.xml  { render :xml => @organisation.errors, :status => :unprocessable_entity }
       end
     end
   end
end
