class Admin < ActiveRecord::Base
  devise :database_authenticatable, :trackable, :timeoutable, :lockable, :rpx_connectable
  acts_as_tagger
end
