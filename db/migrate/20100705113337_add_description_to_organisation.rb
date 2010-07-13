class AddDescriptionToOrganisation < ActiveRecord::Migration
  def self.up
    change_table "organisations" do |t|
      t.text :description
    end
  end

  def self.down
    change_table "organisations" do |t|
      t.remove :description
    end
  end
end
