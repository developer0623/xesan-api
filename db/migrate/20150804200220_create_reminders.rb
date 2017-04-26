class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.belongs_to :medication, index: true
      t.belongs_to :user, index: true

      t.string :guid
      t.boolean :sunday, default: true
      t.boolean :monday, default: true
      t.boolean :tuesday, default: true
      t.boolean :wednesday, default: true
      t.boolean :thursday, default: true
      t.boolean :friday, default: true
      t.boolean :saturday, default: true

      t.integer :hour, min: 0, max: 23
      t.integer :minute, min: 0, max: 59

      t.datetime :start_date
      t.datetime :end_date
      t.boolean :deleted
    end
  end
end
