require 'spec_helper'

describe Event do
  
  
  fixtures :events, :organisations, :tags, :taggings, :people
  
  before(:each) do
    @valid_attributes = {
      :title => 'Moonies\' meet',
      :start_date => DateTime.new + 1.week,
      :location => 'Cult house 1'
    }
    
    SearchFilter.new(Event::EVENT_FILTER_SETUP, Event::EVENT_FILTER_KEY)
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
  
  context "reminders" do
    
    it "should expose a method that returns all events that should be sent a reminder" do
      
      event_user_pairs = Event.event_user_pairs_for_reminder(3)
      
      event_user_pairs.length.should == 1
      event_user_pairs.first.first.should be_an_instance_of Event
      event_user_pairs.first.last.should be_an_instance_of Person
      
    end
    
  end
  
  context "anti-duping" do
    
    it "should expose a predicate to check whether a hash of event attributes is the dupe of one in the db" do
      
      Event.is_duped?(events(:moonies_meetup).attributes).should == true
      Event.is_duped?({'title' => 'Not in db', 'start_date' => Time.now}).should == false
      
    end
    
  end
  
end