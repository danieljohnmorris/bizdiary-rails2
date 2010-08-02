class SitemapController < ApplicationController
  def sitemap
    @events = Event.find(:all, :order => "updated_at DESC", :limit => 50000)
    headers["Content-Type"] = "text/xml"
    # set last modified header to the date of the latest entry.
    headers["Last-Modified"] = @events.first.updated_at.httpdate    
    
    render :layout => false
  end
end
