require 'spec_helper'

describe SearchFilter do
  
  before :each do
    @filter = SearchFilter.new({:organiser => :id, :tag => :text}, :test_filter)
  end
  
  it "should keep and index of all filters for easy access" do
    @filter.should equal SearchFilter.filter_index[:test_filter]
  end
  
  it "should prepare filters by a hash, ignoring invalid filters and preparing values" do
  
    input = {:organiser => '1', :tag => 'save', :invalid => :blah}
  
    prepared = @filter.prepare_filters(input)
    prepared.should == {
      :organiser => '1',
      :tag     =>  'save'
    }
  end
  
  it "should load in filters " do
    
    current = {:organiser => '1', :tag => 'save', :invalid => :blah}
    
    @filter.load_filters(current)
    
    (@filter.current_filters.keys & [:organiser, :tag]).length.should == 2
    
  end
  
end