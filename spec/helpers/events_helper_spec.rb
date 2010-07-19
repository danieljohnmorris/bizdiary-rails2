describe EventsHelper do 
  
  it "should prepare filters by a hash, ignoring invalid filters and preparing values" do
    
    input = {:organiser => '1', :tags => '1,2,5', :invalid => :blah}
    setup = {:organiser => :id, :tags => :ids}
    
    prepared = helper.prepare_filters(input, setup)
    prepared.should == {
      :organiser => '1',
      :tags      => %w[1 2 5]
    }
  end
end