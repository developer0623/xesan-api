require 'rails_helper'

RSpec.describe DoctorsController, type: :controller do

  before do
    Doctor.delete_all
    @user = create(:user)

    @user.providers.delete_all

    @doctors = build_list(:doctor, 3)
    @doctors.each do |b|
      b.save!
    end
  end

  describe "index" do

    before do
      Provider.destroy_all

      @provider = Provider.create!({
        npi: 1346675691,
        entity_type_code: "1",
        replacement_npi: nil,
        employer_identification_number: nil,
        organization_name: nil,
        last_name: "JONES",
        first_name: "LARAE",
        middle_name: "J",
        name_prefix_text: nil,
        name_suffix_text: nil,
        credential_text: "ARNP",
        other_organization_name: nil,
        other_organization_name_type_code: nil,
        other_last_name: nil,
        other_first_name: nil,
        other_middle_name: nil,
        other_name_prefix_text: nil,
        other_name_suffix_text: nil,
        other_credential_text: nil,
        other_last_name_type_code: nil,
        first_line_business_address: "516 GROVE PARK BLVD",
        business_mailing_address_city_name: "JACKSONVILLE",
        mailing_address_state_name: "FL",
        business_mailing_address_postal_code: "32216",
        business_mailing_address_country_code: "US",
        business_mailing_address_telephone_number: "9049930124",
        business_mailing_address_fax_number: nil,
        first_line_location_address: "120 SAINT JOHNS COMMONS RD",
        second_line_location_address: nil,
        location_address_city_name: "JACKSONVILLE",
        location_address_state_name: "FL",
        location_address_postal_code: "32259",
        location_address_country_code: "US",
        location_address_telephone_number: "8663892727",
        location_address_fax_number: nil,
        enumeration_date: "2013-09-05",
        last_update_date: "2015-03-02",
        npi_deactivation_reason_code: nil,
        npi_deactivation_date: nil,
        npi_reactivation_date: nil,
        gender_code: "F",
        authorized_official_last_name: nil,
        authorized_official_first_name: nil,
        authorized_official_middle_name: nil,
        authorized_official_title_or_position: nil,
        authorized_official_telephone_number: nil,
        is_sole_proprietor: false,
        is_organization_subpart: false,
        parent_organization_lbn: nil,
        parent_organization_tin: nil,
        authorized_official_name_prefix_text: nil,
        authorized_official_name_suffix_text: nil,
        authorized_official_credential_text: nil,
        geo: "POINT (-81.5116773 30.0606664)",
        is_pharmacy: false,
        created_at: "2015-10-03 17:54:42",
        updated_at: "2015-10-03 17:54:42"
      })
    end
    it "should find doctors by name" do
      expect(Doctor.count).to eq(1)

      login_with @user

      get :index, {
        latlon: '30.0189715,-81.3866573',
        q: "lara"
      }

      json = JSON.parse(response.body)
      expect(json.count).to eq(1)
      expect(json[0]['distance']).to_not be_nil
    end

  end


end
