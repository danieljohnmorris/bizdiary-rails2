class DropEndTimeFromEvents < ActiveRecord::Migration
  def self.up
    change_table "events" do |t|
      t.remove :end_time
    end
  end

  def self.down
    change_table "events" do |t|
      t.datetime :end_time
    end
  end
end
