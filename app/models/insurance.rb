class Insurance < ActiveRecord::Base
  belongs_to :user

  def as_json(options = {})
    {
      id: id,
      userId: user_id,
      companyName: company_name,
      streetAddress: street_address,
      city: city,
      state: state,
      zip: zip,
      planCode: plan_code,
      idNumber: id_number,
      groupNumber: group_number,
      rxBin: rx_bin,
      rxPCN: rx_pcn,
      rxGroup: rx_group,
      coverage: coverage,
      officeCopay: office_copay,
      specialistCopay: specialist_copay,
      annualDeductible: annual_deductible,
      deductibleEffectiveDate: deductible_effective_date,
      memberServiesPhone: member_servies_phone,
      providerServicesPhone: provider_services_phone,
      pharmacistServicesPhone: pharmacist_services_phone,
      nurseLinePhone: nurse_line_phone,
      website: website
    }
  end
end
