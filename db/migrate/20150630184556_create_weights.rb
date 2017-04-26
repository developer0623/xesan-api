class CreateWeights < ActiveRecord::Migration
  def change
    create_table :weights do |t|
      t.belongs_to :user, index: true
      t.float :weight
      t.string :units, default: 'lbs'
      t.timestamp :created_at
    end
  end
end
