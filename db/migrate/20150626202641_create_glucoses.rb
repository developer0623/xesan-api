class CreateGlucoses < ActiveRecord::Migration
  def change
    create_table :glucoses do |t|
      t.belongs_to :user, index: true

      t.float :value
      t.string :units, default: 'mg/dL'
      t.jsonb :activities, default: []
      t.string :notes
      t.boolean :is_control, default: false

      t.timestamp :created_at
    end
  end
end
