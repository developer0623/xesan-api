class CreateGlucoseStripBottles < ActiveRecord::Migration
  def change
    create_table :glucose_strip_bottles do |t|
      t.belongs_to :user, index: true

      t.integer :strip_count
      t.date :expiration
      t.date :opened
      t.string :lot_number
      t.boolean :current

      t.timestamps null: false
    end
  end
end
