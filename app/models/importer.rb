class Importer
  
  def self.import_event_vos event_vos
    
    p 'IMPORTING!'
    imported = 0
    event_vos.each do |event_vo|
      
      event = Event.new event_vo[:fields]
      
      # avoid duplicates on event, by looking at title and start_date, and on org by name
      next if Event.is_dupe?(event.attributes)
      
      event_vo[:related_to].each do |r|
        if(r[:type] == :Organiser)
          organisation = Organisation.new r[:fields]
          event.organisation = Organisation.create_or_retrieve_if_dupe(organisation.attributes)
        end
      end if event_vo[:related_to] && event_vo[:related_to].length > 0
      
      event.save
      imported += 1
    end
    
    p "Imported #{imported} events"
  end
  
end