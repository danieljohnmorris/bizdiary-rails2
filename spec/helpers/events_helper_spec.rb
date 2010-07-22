describe EventsHelper do 
  
  before :each do
    
    @filter = SearchFilter.new({:topic => :text, :organisation => :text}, :event_filter)
  end
  
  context "view" do
    
    it "should expose a helper that builds new filter paramters on existing ones" do
      
      /topic=networking/.should match helper.filter_path({:topic => 'networking'})
      
      @filter.current_filters = {:topic => 'networking'}
      /topic=networking.*organisation=1|organisation=1.*topic=networking/.should match helper.filter_path({:organisation => 1})
      
    end
  end

end