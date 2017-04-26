class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers, {:id => false} do |t|
      t.integer  :npi
      t.integer   :entity_type_code
      t.string   :replacement_npi
      t.string   :employer_identification_number,                                limit: 9
      t.string   :organization_name,                                    limit: 70
      t.string   :last_name,                                            limit: 35
      t.string   :first_name,                                           limit: 20
      t.string   :middle_name,                                          limit: 20
      t.string   :name_prefix_text,                                     limit: 5
      t.string   :name_suffix_text,                                     limit: 5
      t.string   :credential_text,                                      limit: 20
      t.string   :other_organization_name,                              limit: 70
      t.string   :other_organization_name_type_code,                    limit: 1
      t.string   :other_last_name,                                      limit: 35
      t.string   :other_first_name,                                     limit: 20
      t.string   :other_middle_name,                                    limit: 20
      t.string   :other_name_prefix_text,                               limit: 5
      t.string   :other_name_suffix_text,                               limit: 5
      t.string   :other_credential_text,                                limit: 20
      t.string   :other_last_name_type_code,                            limit: 1
      t.string   :first_line_business_address,                          limit: 55
      t.string   :first_line_business_address,                          limit: 55
      t.string   :business_mailing_address_city_name,                   limit: 40
      t.string   :mailing_address_state_name,                           limit: 40
      t.string   :business_mailing_address_postal_code,                 limit: 20
      t.string   :business_mailing_address_country_code,                 limit: 2
      t.string   :business_mailing_address_telephone_number,            limit: 20
      t.string   :business_mailing_address_fax_number,                  limit: 20
      t.string   :first_line_location_address,        limit: 55
      t.string   :second_line_location_address,       limit: 55
      t.string   :location_address_city_name,         limit: 40
      t.string   :location_address_state_name,        limit: 40
      t.string   :location_address_postal_code,       limit: 5
      t.string   :location_address_country_code,      limit: 2
      t.string   :location_address_telephone_number,  limit: 20
      t.string   :location_address_fax_number,        limit: 20
      t.date   :enumeration_date
      t.date   :last_update_date
      t.string   :npi_deactivation_reason_code,                                  limit: 2
      t.date   :npi_deactivation_date
      t.date   :npi_reactivation_date
      t.string   :gender_code,                                          limit: 1
      t.string   :authorized_official_last_name,                                 limit: 35
      t.string   :authorized_official_first_name,                                limit: 20
      t.string   :authorized_official_middle_name,                               limit: 20
      t.string   :authorized_official_title_or_position,                         limit: 35
      t.string   :authorized_official_telephone_number,                          limit: 20
      t.boolean   :is_sole_proprietor
      t.boolean   :is_organization_subpart
      t.string   :parent_organization_lbn,                                       limit: 70
      t.string   :parent_organization_tin,                                       limit: 9
      t.string   :authorized_official_name_prefix_text,                          limit: 5
      t.string   :authorized_official_name_suffix_text,                          limit: 5
      t.string   :authorized_official_credential_text,                           limit: 20
      t.st_point :geo, geographic: true
      t.boolean :is_pharmacy, default: false

      t.timestamps
    end

    add_index :providers, :npi, unique: true
    add_index :providers, :geo, using: :gist
    add_index :providers, :location_address_postal_code, name: 'postal_code'

    execute "ALTER TABLE providers ADD PRIMARY KEY (npi);"

    execute "CREATE INDEX index_provs_on_lowercase_name
             ON providers (lower(organization_name || ' ' || other_organization_name));"

    execute "CREATE INDEX index_provs_on_lowercase_address
             ON providers (lower(first_line_location_address || ' ' || second_line_location_address));"

    execute "CREATE INDEX index_provs_on_lowercase_city
             ON providers (lower(location_address_city_name));"

    execute "CREATE INDEX index_provs_on_lowercase_state
             ON providers (lower(location_address_state_name));"

    execute "CREATE INDEX index_provs_on_lowercase_first_name
             ON providers (lower(first_name));"

    execute "CREATE INDEX index_provs_on_lowercase_middle_name
             ON providers (lower(middle_name));"

    execute "CREATE INDEX index_provs_on_lowercase_last_name
             ON providers (lower(last_name));"

    execute "CREATE INDEX index_provs_on_name_and_address
             ON providers (lower(first_name || ' ' || last_name || ' ' || location_address_city_name || ' ' || location_address_state_name));"
  end
end
