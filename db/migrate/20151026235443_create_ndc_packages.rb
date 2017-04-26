class CreateNdcPackages < ActiveRecord::Migration
  def change
    create_table :ndc_packages do |t|
      t.integer :ndc_product_id               # foreign key, to ndc_products: ID
      t.string :ndc_product_code, limit: 10             # 10000 ---> 999999999, not unique
      t.string :ndc_package_code, limit: 13   # xxxxx-xxxx-xx
      t.string :fda_native_code, limit: 13   # xxxxx-xxxx-xx
      t.string :description  #orginal package description
    end

    add_index :ndc_packages, :ndc_product_id
    add_index :ndc_packages, :ndc_package_code

    execute "ALTER TABLE ndc_packages ADD CONSTRAINT fk_ndc_packages_to_ndc_products FOREIGN KEY (ndc_product_id) REFERENCES ndc_products (id) MATCH FULL;"
  end
end
