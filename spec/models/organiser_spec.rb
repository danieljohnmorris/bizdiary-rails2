require 'spec_helper'

describe Organisation do
  
  fixtures :organisations, :events
  
  before(:each) do
    @valid_attributes = {
      :name => 'Moooooonies',
    }
    
  end

  it "should create a new instance given valid attributes" do
    Organisation.create!(@valid_attributes)
  end
  
  context "anti-duping" do
    
    it "should expose a method to find or create an organisation based on whether a hash of attrs is the dupe of one in the db" do
      
      Organisation.create_or_retrieve_if_dupe(organisations(:moonies).attributes).id.should == organisations(:moonies).id
      
      pre = Organisation.all.length
      Organisation.create_or_retrieve_if_dupe({'name' => 'Not in db'})
      (Organisation.all.length > pre).should == true
    end
    
  end
  
end