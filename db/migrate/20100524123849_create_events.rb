class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.text :description
      t.text :location
      t.datetime :start_time
      t.datetime :end_time
      t.string :url
      t.string :telephone
      t.string :email
      t.text :people
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
