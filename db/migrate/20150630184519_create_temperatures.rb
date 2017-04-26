class CreateTemperatures < ActiveRecord::Migration
  def change
    create_table :temperatures do |t|
      t.belongs_to :user, index: true
      t.float :temperature
      t.string :units, default: 'F'
      t.timestamp :created_at
    end
  end
end

