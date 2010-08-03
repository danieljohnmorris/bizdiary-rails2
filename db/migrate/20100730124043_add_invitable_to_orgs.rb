class AddInvitableToOrgs < ActiveRecord::Migration
  def self.up
    change_table :organisations do |t|
      t.string :invitation_token, :limit => 20
      t.datetime :invitation_sent_at
      t.index :invitation_token
    end

    # Allow null encrypted_password and password_salt
    change_column :organisations, :encrypted_password, :string, :null => true
    change_column :organisations, :password_salt, :string, :null => true
  end

  def self.down
    change_table :organisations do |t|
      t.remove  :invitation_token, :limit => 20
      t.remove  :invitation_sent_at
      t.remove  :invitation_token
    end
  end
end
