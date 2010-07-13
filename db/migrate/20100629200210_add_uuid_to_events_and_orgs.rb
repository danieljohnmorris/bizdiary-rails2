class AddUuidToEventsAndOrgs < ActiveRecord::Migration
  def self.up
    change_table "events" do |t|
      t.string :uuid
    end
    change_table "organisations" do |t|
      t.string :uuid
    end
  end

  def self.down
    change_table "events" do |t|
      t.remove :uuid
    end
    change_table "organisations" do |t|
      t.remove :uuid
    end
  end
end
