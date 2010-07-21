# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Admin.create(:email => "dan@cothink.co.uk", :password => "startupfun")
Admin.create(:email => "tim@cothink.co.uk", :password => "startupfun")
Admin.create(:email => "finbar@cothink.co.uk", :password => "startupfun")

Admin.create(:email => "staff@cothink.co.uk", :password => "R>h2]ZD")