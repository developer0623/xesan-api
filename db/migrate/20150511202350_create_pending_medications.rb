class CreatePendingMedications < ActiveRecord::Migration
  def change
    create_table :pending_medications do |t|
      t.belongs_to :user, index: true
      t.string :status
      t.jsonb :images
      t.timestamps null: false
    end
  end
end
