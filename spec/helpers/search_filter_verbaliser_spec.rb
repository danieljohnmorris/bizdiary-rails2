require 'spec_helper'

describe EventsHelper do
  
  it "should turn filters into a sentence" do
    
    input = {:type => 'seminar'}
    
    result = helper._verbalise_filters(15, input)
    
    /Found 15 seminars/.should match result
    
  end
  
  it "should use default if supplied without a value" do
    
    result = helper._verbalise_filters(12, {})
    /Found 12 events/.should match result
    
  end
  
  it "should include count" do
    
    result = helper._verbalise_filters(15,{})
    /Found 15 events/.should match result
    
  end
    
  
end