class AddDeviseToOrgs < ActiveRecord::Migration
  def self.up
    change_table(:organisations) do |t|
      t.string   "email",                               :default => "", :null => false
      t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
      t.string   "password_salt",                       :default => "", :null => false
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "reset_password_token"
      t.string   "remember_token"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",                       :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.string   "rpx_identifier"
    end
  end

  def self.down
    change_table(:organisations) do |t|
      t.remove "email",                               :default => "", :null => false
      t.remove "encrypted_password"
      t.remove "password_salt"
      t.remove "confirmation_token"
      t.remove "confirmed_at"
      t.remove "confirmation_sent_at"
      t.remove "reset_password_token"
      t.remove "remember_token"
      t.remove "remember_created_at"
      t.remove "sign_in_count"
      t.remove "current_sign_in_at"
      t.remove "last_sign_in_at"
      t.remove "current_sign_in_ip"
      t.remove "last_sign_in_ip"
      t.remove "rpx_identifier"
    end
  end
end