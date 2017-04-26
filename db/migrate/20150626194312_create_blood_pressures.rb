class CreateBloodPressures < ActiveRecord::Migration
  def change
    create_table :blood_pressures do |t|
      t.belongs_to :user, index: true
      t.float :systolic
      t.float :diastolic
      t.string :units, default: 'mm/HG'
      t.timestamp :created_at
    end
  end
end
