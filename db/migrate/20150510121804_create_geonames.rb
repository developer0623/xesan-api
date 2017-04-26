class CreateGeonames < ActiveRecord::Migration
  def change
    create_table :geonames do |t|

      t.string "zip"
      t.string "city"
      t.string "state"
      t.string "county"

      t.st_point :lonlat, geographic: true

      t.timestamps null: false
    end

    add_index :geonames, :zip
  end
end
