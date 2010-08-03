require 'spec_helper'

# this is a functional spec, as the duping logical is stored probiously in the Event/Organisation models
describe Importer do
  
  before :each do
    @test_data = YAML.load_file(TEST_DATA_DIR + '/importer_spec.yml')
  end
  
  it "should create events with the fields contained with vos" do
    Importer.import_event_vos(@test_data[:all_unique])
    Event.find_all_by_title('Becoming an Employer - What You Need to Know').length.should == 2
  end
  
  it "should create related Organisation objects" do
    
    Organisation.should_receive(:create_or_retrieve_if_dupe).exactly(2).times
    Importer.import_event_vos(@test_data[:all_unique])
  end
  
  it "should avoid duping organisations" do
    
    Importer.import_event_vos(@test_data[:organisation_duped])
    Organisation.find_all_by_name('HM Revenue &amp; Customs').length.should == 1

  end
  
  it "should avoid duping events" do
    
    Importer.import_event_vos(@test_data[:events_duped])
    
    Event.find_all_by_title("Becoming an Employer - What You Need to Know").length.should == 1

  end
  
  
end