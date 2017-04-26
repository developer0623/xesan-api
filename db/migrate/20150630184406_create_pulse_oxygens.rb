class CreatePulseOxygens < ActiveRecord::Migration
  def change
    create_table :pulse_oxygens do |t|
      t.belongs_to :user, index: true
      t.float :pulse_oxygen
      t.string :units, default: 'SpO2'
      t.timestamp :created_at
    end
  end
end
