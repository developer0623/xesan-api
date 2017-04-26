class NdcPackage < ActiveRecord::Base
  belongs_to :NdcProduct

  def self.setup_seed_data
    ActiveRecord::Base.connection.execute(%Q{
      INSERT INTO ndc_products (
            product_id,
            product_ndc,
            product_type_name,
            proprietary_name,
            proprietary_name_suffix,
            dosage_form_name,
            route_name,
            substance_name,
            active_numerator_strength,
            active_ingred_unit
      )
      SELECT '0002-3228_7ad983d7-6ac4-4560-a5a7-0c9151cd383',
              '00002-3228', 'HUMAN PRESCRIPTION DRUG','Strattera',
              '', 'CAPSULE', 'ORAL','ATOMOXETINE HYDROCHLORIDE',
              '25', 'mg/1'
      WHERE NOT EXISTS (
        SELECT * FROM ndc_products WHERE product_ndc = '00002-3228')
    })

    ActiveRecord::Base.connection.execute(%Q{
      INSERT INTO ndc_packages(
            ndc_product_id,
            ndc_product_code,
            ndc_package_code,
            fda_native_code,
            description)
      SELECT id, '00002-3228', '00002-3228-07', '0002-3228-07', '7 CAPSULE in 1 BOTTLE'
      FROM ndc_products
      WHERE product_ndc = '00002-3228'
        AND NOT EXISTS (
          SELECT * FROM ndc_packages WHERE ndc_package_code = '00002-3228-07')
    })
  end

  def as_json(options = {})
    json = {
      fda_native_code: fda_native_code,
      description: description,
      ndc_package_code: ndc_package_code,
      ndc_product_id: ndc_product_id
    }
    return json
  end

end
