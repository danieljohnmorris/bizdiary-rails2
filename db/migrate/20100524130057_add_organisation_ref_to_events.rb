class AddOrganisationRefToEvents < ActiveRecord::Migration
  def self.up
    change_table "events" do |t|
      t.belongs_to :organisation
    end
  end

  def self.down
    change_table "events" do |t|
      t.remove :organisation
    end
  end
end
