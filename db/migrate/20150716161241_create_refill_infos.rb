class CreateRefillInfos < ActiveRecord::Migration
  def change
    create_table :refill_infos do |t|
      t.belongs_to :medication, index: true
      t.string :rx_number
      t.date :rx_fill_date
      t.integer :refill_num
      t.integer :refill_total
      t.integer :current_med_count
      t.integer :days_supply
      t.date :discard_date
      t.date :refills_expiration
      t.timestamp :created_at
      t.boolean :active_refill, default: true
    end
  end
end
