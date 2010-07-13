class ChangeEventToIcalformat < ActiveRecord::Migration
  def self.up
    change_table "events" do |t|
      t.rename :start_time, :start_date
    end
  end

  def self.down
    change_table "events" do |t|
       t.rename :start_date, :start_time
    end
  end
end
