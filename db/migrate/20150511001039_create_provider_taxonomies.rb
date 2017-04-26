class CreateProviderTaxonomies < ActiveRecord::Migration
  def change
    create_table :provider_taxonomies do |t|
      t.integer :provider_id
      t.string  :code, limit: 10
      t.string  :taxonomy
      t.boolean :primary
      t.timestamps
    end

    add_index :provider_taxonomies, :provider_id
    add_index :provider_taxonomies, :code
  end
end
