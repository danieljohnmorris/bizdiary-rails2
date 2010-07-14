module ApplicationHelper
 # assets version
 def assets
   "assets/1"
 end
end

# to allow for escaping strings in views that may be nil
class NilClass
  def html_safe
    
  end
end

# keeping things DRY and easy to change, here's the canonical display format for LIST dates
# WHAT DOES BD MEAN?
module BdDateFormat
  def bd_date_format
    strftime('%a, %e %b').gsub(/0(\d)/, '\1')
  end
  def full_date_format
    strftime('%a, %d %b - %I:%M %p')
  end
end

class Date
  include BdDateFormat
end
class Time
  include BdDateFormat
end
class DateTime
  include BdDateFormat
end