#require File.dirname(__FILE__) + '/../../vendor/plugins/cothink/lib/helpers/date'
module EventsHelper
  
#  include ::Cothink::Helpers::Date
  
  @@week_names = ['This Week','Next Week','Week After Next']
  
  def map_link(address)
    link_to "map", 'http://maps.google.co.uk?q=' + CGI.escape(address), :class => 'map-link'
  end
  
  def event_publish_states
    {"Draft" => 0, "Published" => 1}
  end
  
  # render events, and week and days for all distinct dates
  def render_events(events)
    output = ''
    last_date =  Date.parse('1970-1-1')
    events.each do |event|
      
      week, calendar_page = '',''
      
      unless last_date.strftime('%W') == event.start_date.strftime('%W')
        #week = render_week(event.start_date)
      end
      unless last_date.day == event.start_date.day
         calendar_page = render_calendar_page(event.start_date)
      end
      
      output += render(:partial => 'events/event',:locals => {:event=>event, :week=>week, :calendar_page=>calendar_page})
      
      last_date = event.start_date
      
    end
    output
  end
  
  protected
  
  def render_calendar_page(date)
     render(:partial => 'home/calendar_page',:locals => {:day => date.day, :month => date.strftime('%b')})
  end
  def render_week(date)
    
    week_diff = weeks_in_future_of(date,Time.now)
    monday_of_date = monday_of_week_containing(date)
    
    week_of = "Week of #{nice_datify(monday_of_date)}"
    week_name = week_diff >= 0 ? @@week_names[week_diff] || week_of : week_of
    
    range = nice_datify(monday_of_date) + ' - ' + nice_datify(monday_of_date + 6.days)
    
    render(:partial => 'home/week',:locals => {:week => week_name, :range => range})
  end
end