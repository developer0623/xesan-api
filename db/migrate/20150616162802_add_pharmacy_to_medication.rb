class AddPharmacyToMedication < ActiveRecord::Migration
  def change
    add_column :medications, :prescriber_id, :integer
    add_index :medications, :prescriber_id

    add_column :medications, :pharmacy_id, :integer
    add_index :medications, :pharmacy_id
  end
end
