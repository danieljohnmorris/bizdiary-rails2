require 'spec_helper'

describe Event do
  
  
  fixtures :events, :organisations, :tags, :taggings, :people
  
  before(:each) do
    @valid_attributes = {
      :title => 'Moonies\' meet',
      :start_date => DateTime.new + 1.week,
      :location => 'Cult house 1'
    }
  end

  it "should create a new instance given valid attributes" do
    Event.create!(@valid_attributes)
  end
  
  context "filtering" do
    
    it "should show events only by organisation" do
      
      (result = Event.filtered(:organisation => organisations('moonies').id).all).length.should == 1
      result.first.title = events('moonies_meetup').title
      
    end
    
    it "should show events starred by someone" do
      
      Event.filtered({:starred => true},people('bill')).first.title.should == events('moonies_meetup').title
      
    end
    
    
    
  end
  
end