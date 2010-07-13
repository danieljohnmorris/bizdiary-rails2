class AddScraperFieldsToEvents < ActiveRecord::Migration
  def self.up
    change_table "events" do |t|
      t.string :cost
      t.string :intended_audience
    end
  end

  def self.down
    change_table "events" do |t|
      t.remove :cost
      t.remove :intended_audience
    end
  end
end
