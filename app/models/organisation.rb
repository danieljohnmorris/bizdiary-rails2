class Organisation < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :rpx_connectable
  has_many :events
  acts_as_taggable_on :saves

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
end
