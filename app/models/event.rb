require 'fastercsv'

class Event < ActiveRecord::Base
  
  belongs_to :organisation
  
  # tagging
  acts_as_taggable_on :saves, :topics, :types, :industries

  validates_presence_of :title, :start_date, :location # minimum useful fields

  #pub state
  DRAFT_STATE = 0
  PUBLISHED_STATE = 1
  
  # star
  STAR_TAG = 'star'
  
  attr_protected :publish_state
  
  # scopes
  named_scope :published, lambda {{ :conditions => ["publish_state = ?", PUBLISHED_STATE] }}    
  named_scope :drafts, lambda {{ :conditions => ["publish_state = ?", DRAFT_STATE] }}
  
  named_scope :by_start_date_backward, :order => "start_date DESC"
  named_scope :by_start_date_forward, :order => "start_date ASC"
  named_scope :in_the_past, lambda {{ :conditions => ["start_date < NOW()"] }}    
  named_scope :in_the_future, lambda {{ :conditions => ["start_date >= NOW()"] }}
  
  # /events/filter?organisation=5&q=london
  # topic 1+5 -> 1,5
  def self.filtered(filters, person = nil)
    scope = scoped({})
    filters.each_pair do |filter_name, filter_args|
      next unless [:organisation, :topic, :type, :industry, :starred, :q].include? filter_name.to_sym
      
      # if you add a condition, make sure you put in in the list above too
      # Keep chaining up scope - scope can take extra scopes, and acts_as_taggable tagged_with
      # is just a scope
      scope = case filter_name
               when :organisation
                 scope.scoped :include => :organisation, :conditions => {:organisations => {:id => filter_args}}
               when :topic
                 scope.tagged_with(filter_args, :on => :topics)
               when :type
                 scope.tagged_with(filter_args, :on => :types)
               when :industry
                 scope.tagged_with(filter_args, :on => :industries)
               when :starred
                 raise "Can't filter for a person's starred events without the person" unless person
                 scope.tagged_with(STAR_TAG, :on => :saves, :by => person)
               when :q
                # TODO - this will be a little more involved, as we'll need to use sphinx_scopes
                # as sphinx doesn't use SQL for queries, but its separate sphinx server
                # http://freelancing-god.github.com/ts/en/
             end
    end
    scope
  end

  def combined_tags
    topics = {:topic => self.topics.to_a}
    event_types = {:type => self.types.to_a}
    industries = {:industry => self.industries.to_a}
    
    topics.merge(event_types.merge(industries)) # return as 1 hash
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
    person.owned_taggings(:context => :saves, :tag => STAR_TAG).collect { |t| t.taggable }
  end

  def starred
    taggings(:context => :saves, :tag => STAR_TAG)
  end

  def star(person)
    person.tag(self, :with => STAR_TAG, :on => :saves)
  end

  def unstar(person)
    person.tag(self, :with => "", :on => :saves)
  end
  
  ### publish pseudo state machine
    
  # rails 2 style:
  #named_scope :published, :conditions => ["publish_state = #{Event::PUBLISHED_STATE}"]
  #named_scope :drafts, :conditions => ["publish_state = #{Event::DRAFT_STATE}"]
  
  # # rails 3 style:
  # scope :published, where("publish_state = ?", Event::PUBLISHED_STATE)
  # scope :drafts, where("publish_state = ?", Event::DRAFT_STATE)
    
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
    indexes location
    
    set_property :field_weights => {
      :title          => 5,
      :description    => 3,
      :location       => 5,
      :organisation   => 5
    }
  end
  
end
