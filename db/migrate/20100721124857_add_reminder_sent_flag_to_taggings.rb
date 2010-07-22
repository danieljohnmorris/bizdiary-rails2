class AddReminderSentFlagToTaggings < ActiveRecord::Migration
  def self.up
    change_table(:taggings) do |t|
      t.date :reminder_sent_on
    end
  end

  def self.down
    change_table(:taggings) do |t|
      t.remove :reminder_sent_on      
    end
  end
end