class Provider < ActiveRecord::Base
  has_many :provider_identifiers
  has_many :provider_taxonomies

  has_and_belongs_to_many :users

  def name
    if entity_type_code == '1'
      [first_name, middle_name, last_name, name_suffix_text, credential_text].join(' ')
    else
      self.organization_name
    end
  end

  def other_name
    ret = if entity_type_code == '1'
      [name_type_code_xref(other_last_name_type_code), other_first_name, other_middle_name, other_last_name, other_name_suffix_text, other_credential_text].join(' ')
    else
      name_type_code_xref(other_organization_name_type_code) + ' ' + self.other_organization_name
    end

    ret.to_s.strip.blank? ? nil : ret
  end

  def as_json(options = {})

    if (last_name && first_name)
      n = first_name
      n = n + ' ' + middle_name if middle_name
      n = n + ' ' + last_name
      # n = %Q{#{first_name} #{last_name}}
    else
      n = other_organization_name || organization_name
    end

    json = {
      npi: npi,
      street: first_line_location_address,
      city: location_address_city_name,
      state: location_address_state_name,
      zip: location_address_postal_code,
      phone: location_address_telephone_number,
      fax: location_address_fax_number,
      gender: gender_code,
      credentials: credential_text,
      lastName: last_name,
      firstName: first_name,
      name: n,
    }


    json[:distance] = (distance / 1609.34).round(2) if respond_to?(:distance)

    json[:display] = %Q{#{n} - #{first_line_location_address} #{location_address_city_name}, #{location_address_state_name} #{location_address_postal_code}};
    return json
  end

end
