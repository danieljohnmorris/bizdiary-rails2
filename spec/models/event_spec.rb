require 'spec_helper'

describe Event do
  
  
  fixtures :events, :organisations, :tags, :taggings
  
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
      
      Event.filtered(:organisation => organisations('moonies').id).all.length.should == 1
    end
    
    
    
  end
  
end