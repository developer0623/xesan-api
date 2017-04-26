#data import staging table, storing raw data
class CreateDataImportNdcPackages < ActiveRecord::Migration
  def change
    create_table :data_import_ndc_packages do |t|
      t.string :PRODUCTID, limit: 48
      t.string :PRODUCTNDC
      t.string :NDCPACKAGECODE
      t.string :PACKAGEDESCRIPTION
    end
  end
end
