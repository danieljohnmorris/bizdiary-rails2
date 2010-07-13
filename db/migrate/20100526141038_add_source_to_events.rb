class AddSourceToEvents < ActiveRecord::Migration
  def self.up
    change_table "events" do |t|
      t.string :source
    end
  end

  def self.down
    change_table "events" do |t|
       t.remove :source
    end
  end
end
