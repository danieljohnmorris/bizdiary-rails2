class AddDeviseToOrgs < ActiveRecord::Migration
  def self.up
    change_table :organisations do |t|
      t.string    "email",                             :default => "", :null => false
      t.string    "encrypted_password", :limit => 128, :default => "", :null => false
      t.string    "password_salt",                     :default => "", :null => false
      t.integer   "failed_attempts",                   :default => 0
      t.string    "unlock_token"
      t.datetime  "locked_at"
      t.integer   "sign_in_count",                     :default => 0
      t.datetime  "current_sign_in_at"
      t.datetime  "last_sign_in_at"
      t.string    "current_sign_in_ip"
      t.string    "last_sign_in_ip"
    end
  end

  def self.down
    change_table :organisations do |t|
      t.remove  "email",                             :default => "", :null => false
      t.remove  "encrypted_password", :limit => 128, :default => "", :null => false
      t.remove  "password_salt",                     :default => "", :null => false
      t.remove  "failed_attempts",                   :default => 0
      t.remove  "unlock_token"
      t.remove  "locked_at"
      t.remove  "sign_in_count",                     :default => 0
      t.remove  "current_sign_in_at"
      t.remove  "last_sign_in_at"
      t.remove  "current_sign_in_ip"
      t.remove  "last_sign_in_ip"
    end
  end
end
