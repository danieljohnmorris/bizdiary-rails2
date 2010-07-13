class AddPublishFlagToEvents < ActiveRecord::Migration
  def self.up
    change_table "events" do |t|
      t.integer :publish_state, :default => 0
    end
  end

  def self.down
    change_table "events" do |t|
      t.remove :publish_state
    end
  end
end
