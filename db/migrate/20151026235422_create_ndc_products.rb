class CreateNdcProducts < ActiveRecord::Migration
  def change
    create_table :ndc_products do |t|
      t.string :product_id,               limit: 48   # 0078-0344_aa024b22-8a80-4e58-b809-8cafb8c1e06e
      t.string :product_ndc,              limit: 10   # not unique. 10000 ---> 999999999
      t.string :product_type_name,        limit: 32
      t.string :proprietary_name,         limit: 256
      t.string :proprietary_name_suffix,  limit: 128
      t.string :nonproprietary_name,      limit: 512
      t.string :dosage_form_name,         limit: 64
      t.string :route_name,               limit: 196
      t.date :start_marketing_date
      t.date :end_marketing_date
      t.string :marketing_category_name,  limit: 48
      #CREATE TYPE category AS ENUM ('nda', ...);
      t.string :application_number,       limit: 11
      t.string :label_name,               limit: 128
      t.string :substance_name
      t.string :active_numerator_strength
      t.string :active_ingred_unit
      t.string :pharm_classes
      t.string :dea_schedule,              limit: 8
      #CREATE TYPE dea_schedule AS ENUM ('CIII', ...);
    end

    add_index :ndc_products, :product_id, unique: true #using gin for faster search
    add_index :ndc_products, :product_ndc
  end
end
