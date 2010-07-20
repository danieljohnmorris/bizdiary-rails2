class PeopleController < ApplicationController
    
  # GET /people
  # GET /people.xml
  def index
    @people = Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @people }
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    @Person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @Person }
    end
  end
end
