#data import staging table, storing raw data
class CreateDataImportNdcProducts < ActiveRecord::Migration
  def change
    create_table :data_import_ndc_products do |t|
      t.string :PRODUCTID
      t.string :PRODUCTNDC # 10000 ---> 999999999
      t.string :PRODUCTTYPENAME
      t.string :PROPRIETARYNAME
      t.string :PROPRIETARYNAMESUFFIX
      t.string :NONPROPRIETARYNAME
      t.string :DOSAGEFORMNAME
      t.string :ROUTENAME
      t.string :STARTMARKETINGDATE
      t.string :ENDMARKETINGDATE
      t.string :MARKETINGCATEGORYNAME
      t.string :APPLICATIONNUMBER
      t.string :LABELERNAME
      t.string :SUBSTANCENAME
      t.string :ACTIVE_NUMERATOR_STRENGTH
      t.string :ACTIVE_INGRED_UNIT
      t.string :PHARM_CLASSES
      t.string :DEASCHEDULE
    end
  end
end
