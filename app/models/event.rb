require 'fastercsv'

class Event < ActiveRecord::Base
  belongs_to :organisation

  validates_presence_of :title, :start_date, :location # minimum useful fields

  lambda { {:conditions => ['delete_after < ?', Time.now]} }

  named_scope :by_start_date_backward, :order => "start_date DESC"
  named_scope :by_start_date_forward, :order => "start_date ASC"
  named_scope :in_the_past, lambda {{ :conditions => ["start_date < NOW()"] }}    
  named_scope :in_the_future, lambda {{ :conditions => ["start_date >= NOW()"] }}    

  #pub state
  DRAFT_STATE = 0
  PUBLISHED_STATE = 1
  attr_protected :publish_state
  named_scope :published, lambda {{ :conditions => ["publish_state = ?", PUBLISHED_STATE] }}    
  named_scope :drafts, lambda {{ :conditions => ["publish_state = ?", DRAFT_STATE] }}    

  # tagging
  acts_as_taggable_on :saves, :topics, :types, :industries
  
  def combined_tags
    {:topic => self.topics} + {:type => self.types} + {:industry => self.industries}
  end

  # def industry_tags   
  #   self.industry_taggings.map {|tt|tt.tag}   
  # end
  # def type_tags       
  #   self.type_taggings.map {|tt|tt.tag}       
  # end
  # def topic_tags      
  #   self.topic_taggings.map {|tt|tt.tag}      
  # end
  
  ### starring methods
  
  def starred?(person)
    if self.saves_from(person).length > 0
      starred = true
    else
      starred = false
    end
             
    return starred
  end
  
  def self::starred(person)
    person.owned_taggings(:context => "saves", :tag => "star").collect { |t| t.taggable }
  end

  def starred
    taggings(:context => :saves, :tag => "star")
  end

  def star(person)
    person.tag(self, :with => "star", :on => :saves)
  end

  def unstar(person)
    person.tag(self, :with => "", :on => :saves)
  end
  
  ### publish pseudo state machine
    
  # rails 2 style:
  #named_scope :published, :conditions => ["publish_state = #{Event::PUBLISHED_STATE}"]
  #named_scope :drafts, :conditions => ["publish_state = #{Event::DRAFT_STATE}"]
  
  # rails 3 style:
  scope :published, where("publish_state = ?", Event::PUBLISHED_STATE)
  scope :drafts, where("publish_state = ?", Event::DRAFT_STATE)
    
  def publish
    return true if self.publish_state == PUBLISHED_STATE

    self.publish_state = PUBLISHED_STATE
    return self.save! ? true : false
  end

  def hide
    return true if self.publish_state == DRAFT_STATE
    
    self.publish_state = DRAFT_STATE
    return self.save! ? true : false
  end

  def published?
    return self.publish_state == PUBLISHED_STATE ? true : false
  end

  def draft?
    return self.publish_state == DRAFT_STATE ? true : false
  end
  
  
  ### tim stuffs
  
  def _formatted_date(date,piece)
    date = self.send(date)
    return "" unless date # otherwise get errors

    if piece == 'ampm'
      date.strftime('%p').downcase
    elsif piece == 'day'
      date.day
    elsif piece == 'month'
      date.strftime('%b')
    else
      hour = date.strftime('%I').gsub(/^0/,'')
      minutes = date.strftime('%M')
      minutes == '00' ? hour : "#{hour}.#{minutes}"
    end
  end
  
  define_index do
    indexes title
    indexes description
    indexes organisation(:name), :as => :organisation
  end
  
end
