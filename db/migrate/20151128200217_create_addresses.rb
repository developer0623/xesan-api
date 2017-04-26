class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.belongs_to :user, index: true
      t.string :street
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip
      t.string :type
      t.timestamps null: false
    end
  end
end
