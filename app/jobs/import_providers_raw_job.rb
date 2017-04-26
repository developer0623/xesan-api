class ImportProvidersRawJob

  def before(job)
    @start = Time.now
  end

  def after(job)
    duration = Time.now - @start
    puts("file: #{@filename} took #{duration} seconds")
  end

  def pharmacy_regexp
    @_preg = Regexp.new(/3336[0-9A-Z]*X/)
  end

  def perform(filename, headers)

    # StackProf.run(mode: :cpu, out: "/tmp/#{File.basename(filename)}.dump") do
      @filename = filename

      ActiveRecord::Base.logger.level = Logger::WARN

      # zips = # FL
      #       ['32081', '32082', '32095', '32092', '32259', '32084',
      #       #VA
      #       '20175', '20147', '20148', '22042', '22043', '22046']
      providers = []
      provider_identifiers = []
      provider_taxonomies = []

      File.open(filename, "r") do |file|
        file.each_line do |line|
          row = {}
          line.chomp.split('","').each_with_index do |value, i|
            value = value.gsub(/^"/, '').chomp('"')
            row[headers[i]] = value if (value && value != "")
          end

          # zip = row[:provider_business_practice_location_address_postal_code]
          # zip = zip[0..4] if zip
          # if zips.include?(zip)
            providers.push(get_providers(row))
            provider_identifiers.concat(get_provider_identifiers(row))
            provider_taxonomies.concat(get_provider_taxonomies(row))
          # end
        end
      end

      if (providers.length > 0)
        Provider.import provider_headers, providers, validate: false
        ProviderIdentifier.import provider_identifier_headers, provider_identifiers, validate: false
        ProviderTaxonomy.import provider_taxonomy_headers, provider_taxonomies, validate: false
      end
    # end
  end

  def parse_date(str)
    "#{$3}-#{$1}-#{$2}" if /(\d\d)\/(\d\d)\/(\d\d\d\d)/ =~ str
  end

  def provider_headers
    [
      :npi,
      :entity_type_code,
      :replacement_npi,
      :employer_identification_number,
      :organization_name,
      :last_name,
      :first_name,
      :middle_name,
      :name_prefix_text,
      :name_suffix_text,
      :credential_text,
      :other_organization_name,
      :other_organization_name_type_code,
      :other_last_name,
      :other_first_name,
      :other_middle_name,
      :other_name_prefix_text,
      :other_name_suffix_text,
      :other_credential_text,
      :other_last_name_type_code,

      :first_line_business_address,
      :business_mailing_address_city_name,
      :mailing_address_state_name,
      :business_mailing_address_postal_code,
      :business_mailing_address_country_code,
      :business_mailing_address_telephone_number,
      :business_mailing_address_fax_number,

      :first_line_location_address,
      :second_line_location_address,
      :location_address_city_name,
      :location_address_state_name,
      :location_address_postal_code,
      :location_address_country_code,
      :location_address_telephone_number,
      :location_address_fax_number,
      :enumeration_date,
      :last_update_date,
      :npi_deactivation_reason_code,
      :npi_deactivation_date,
      :npi_reactivation_date,
      :gender_code,
      :authorized_official_last_name,
      :authorized_official_first_name,
      :authorized_official_middle_name,
      :authorized_official_title_or_position,
      :authorized_official_telephone_number,
      :is_sole_proprietor,
      :is_organization_subpart,
      :parent_organization_lbn,
      :parent_organization_tin,
      :authorized_official_name_prefix_text,
      :authorized_official_name_suffix_text,
      :authorized_official_credential_text,
      :is_pharmacy
    ]
  end

  def is_pharmacy(row)
    1.upto(15).each do |num|
      taxonomy = row[:"healthcare_provider_taxonomy_code_#{num}"]
      return false unless taxonomy
      return true if pharmacy_regexp.match(taxonomy)
    end
  end

  def get_providers(row)
    npi = row[:npi]

    if row[:is_sole_proprietor] == 'X'
      is_sole_proprietor = nil
    else
      is_sole_proprietor = row[:is_sole_proprietor] == 'Y'
    end

    if row[:is_organization_subpart] == 'X'
      is_organization_subpart = nil
    else
      is_organization_subpart = row[:is_organization_subpart] == 'Y'
    end

    mailing_zip = row[:provider_business_mailing_address_postal_code]
    mailing_zip = mailing_zip[0..4] if mailing_zip

    location_zip = row[:provider_business_practice_location_address_postal_code]
    location_zip = location_zip[0..4] if location_zip
    [
      npi,
      row[:entity_type_code],
      row[:replacement_npi],
      row[:employer_identification_number_ein],
      row[:provider_organization_name_legal_business_name],
      row[:provider_last_name_legal_name],
      row[:provider_first_name],
      row[:provider_middle_name],
      row[:provider_name_prefix_text],
      row[:provider_name_suffix_text],
      row[:provider_credential_text],
      row[:provider_other_organization_name],
      row[:provider_other_organization_name_type_code],
      row[:provider_other_last_name],
      row[:provider_other_first_name],
      row[:provider_other_middle_name],
      row[:provider_other_name_prefix_text],
      row[:provider_other_name_suffix_text],
      row[:provider_other_credential_text],
      row[:provider_other_last_name_type_code],
      row[:provider_first_line_business_mailing_address],
      row[:provider_business_mailing_address_city_name],
      row[:provider_business_mailing_address_state_name],
      mailing_zip,
      row[:provider_business_mailing_address_country_code_if_outside_us],
      row[:provider_business_mailing_address_telephone_number],
      row[:provider_business_mailing_address_fax_number],
      row[:provider_first_line_business_practice_location_address],
      row[:provider_second_line_business_practice_location_address],
      row[:provider_business_practice_location_address_city_name],
      row[:provider_business_practice_location_address_state_name],
      location_zip,
      row[:provider_business_practice_location_address_country_code_if_outside_us],
      row[:provider_business_practice_location_address_telephone_number],
      row[:provider_business_practice_location_address_fax_number],
      parse_date(row[:provider_enumeration_date]),
      parse_date(row[:last_update_date]),
      row[:npi_deactivation_reason_code],
      parse_date(row[:npi_deactivation_date]),
      parse_date(row[:npi_reactivation_date]),
      row[:provider_gender_code],
      row[:authorized_official_last_name],
      row[:authorized_official_first_name],
      row[:authorized_official_middle_name],
      row[:authorized_official_title_or_position],
      row[:authorized_official_telephone_number],
      is_sole_proprietor,
      is_organization_subpart,
      row[:parent_organization_lbn],
      row[:parent_organization_tin],
      row[:authorized_official_name_prefix_text],
      row[:authorized_official_name_suffix_text],
      row[:authorized_official_credential_text],
      is_pharmacy(row)
    ]
  end

  def provider_identifier_headers
    [
      :provider_id,
      :identifier,
      :type_code,
      :state,
      :additional_info
    ]
  end

  def get_provider_identifiers(row)
    npi = row[:npi]

    provider_identifiers = []

    1.upto(15).each do |num|
      break unless row[:"provider_license_number_#{num}"]

      provider_identifiers.push([
        npi,
        row[:"provider_license_number_#{num}"],
         'LC',
        row[:"provider_license_number_state_code_#{num}"],
        nil
      ])
    end

    1.upto(50).each do |num|
      break unless row[:"other_provider_identifier_#{num}"]

      provider_identifiers.push([
        npi,
        row[:"other_provider_identifier_#{num}"],
        row[:"other_provider_identifier_type_code_#{num}"],
        row[:"other_provider_identifier_state_#{num}"],
        row[:"other_provider_identifier_issuer_#{num}"]
      ])
    end

    return provider_identifiers
  end

  def provider_taxonomy_headers
    [
      :provider_id,
      :taxonomy,
      :primary
    ]
  end

  def get_provider_taxonomies(row)
    npi = row[:npi]

    taxonomies = []

    1.upto(15).each do |num|
      break unless row[:"healthcare_provider_taxonomy_code_#{num}"]

      primary  = row[:"healthcare_provider_primary_taxonomy_switch_#{num}"] == 'Y' ? true : false

      taxonomies.push([
        npi,
        row[:"healthcare_provider_taxonomy_code_#{num}"],
        primary
      ])
    end

    return taxonomies
  end
end
