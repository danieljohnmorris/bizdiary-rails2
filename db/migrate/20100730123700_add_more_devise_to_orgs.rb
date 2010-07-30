class AddMoreDeviseToOrgs < ActiveRecord::Migration
  def self.up
    change_table :organisations do |t|
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "reset_password_token"
      t.string   "remember_token"
      t.datetime "remember_created_at"
      t.string   "rpx_identifier"
    end
  end

  def self.down
    change_table :organisations do |t|
      t.remove  "confirmation_token"
      t.remove  "confirmed_at"
      t.remove  "confirmation_sent_at"
      t.remove  "reset_password_token"
      t.remove  "remember_token"
      t.remove  "remember_created_at"
      t.remove  "rpx_identifier"
    end
  end
end
