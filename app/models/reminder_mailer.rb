class ReminderMailer < ActionMailer::Base
  
  def event_reminder(event, user)
    
    recipients    user.email
    from          "Business Diary reminders <notifications@thebusinessdiary.co.uk>"
    subject       "Reminder for your event"
    sent_on       Time.now
    body          :event => event, :user => user
    
  end
  
  
  
  def self.generate_event_reminders
    
    Event.event_user_pairs_for_reminder.each do |pair|
      
      event, user = pair
      
      ReminderMailer.deliver_event_reminder(event,user)
      
    end
    
  end

end
