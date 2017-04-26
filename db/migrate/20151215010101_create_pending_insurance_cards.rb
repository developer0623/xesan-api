class CreatePendingInsuranceCards < ActiveRecord::Migration
  def change
    create_table :pending_insurance_cards do |t|
      t.belongs_to :user, index: true
      t.string :status
      t.jsonb :images
      t.string :status
      t.timestamps null: false
    end
  end
end
