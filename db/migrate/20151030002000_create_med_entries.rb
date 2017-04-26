class CreateMedEntries < ActiveRecord::Migration
  def change
    create_table :med_entries do |t|

      t.belongs_to :medication, index: true
      t.belongs_to :reminder, index: true
      t.belongs_to :user, index: true

      t.boolean :taken, default: false

      t.timestamp :scheduled_time
      t.timestamp :actual_time
    end
  end
end
