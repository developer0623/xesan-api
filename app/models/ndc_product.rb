class NdcProduct < ActiveRecord::Base
  has_many :NdcPackage

   def as_json(options = {})
    json = {
      name: proprietary_name + (proprietary_name_suffix? ? ' ' + proprietary_name_suffix : ''),
      form: dosage_form_name,
      substance: substance_name,
      strength: active_numerator_strength,
      unit: active_ingred_unit,
      category: product_type_name,
      route: route_name
    }
    return json
  end

end
