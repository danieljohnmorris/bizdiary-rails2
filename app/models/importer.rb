class Importer
  
  def import event_vos_as_yaml
    
    event_vos = YAML.load(event_vos_as_yaml)
    
    event_vos.each do |event_vo|
      
      event = Event.new event_vo[:fields]
      
      # avoid duplicates on event, by looking at title and start_date, and on org by name
      next if Event.is_dupe?(event)
      
      event_vo.related_to.each do |r|
        if(r.type == :Organiser)
          event.organiser = Organiser.create_or_retrieve_if_dupe(r[:fields])
        end
      end
      
      event.save
      
    end
    
  end
  
end