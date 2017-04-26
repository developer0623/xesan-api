class CreateMedications < ActiveRecord::Migration
  def change
    create_table :medications do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.string :dose
      t.integer :frequency
      t.string :frequency_period
      t.string :strength
      t.float :refills_remaining
      t.date :discard_date
      t.string :reason_for_taking
      t.string :form
      t.integer :count
      t.string :route
      t.string :category
      t.string :description
      t.string :instructions
      t.string :ndc

      t.timestamps null: false
    end
  end
end
