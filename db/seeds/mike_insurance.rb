u = User.where(uid: 'mike@gmail.com').first

Insurance.import([:user_id, :company_name, :street_address, :city, :state, :zip, :plan_code, :id_number, :group_number, :rx_bin, :rx_pcn, :rx_group, :coverage, :office_copay, :specialist_copay, :annual_deductible, :deductible_effective_date, :member_servies_phone, :provider_services_phone, :pharmacist_services_phone, :nurse_line_phone, :website, :created_at, :updated_at], [
  [u.id, "BlueCross Blueshield", "P.O. Box 6007", "Los Angeles", "California", "90060", "040", "XDP096A73828", "278342M010", "003858", "A4", "WLHA", "Medical", 20.0, nil, nil, nil, "1-800-888-8288", "1-800-677-6669", "1-800-824-0898", "1-800-700-9186", "anthem.com/ca", "2015-12-07 03:15:27", "2015-12-07 03:15:27"]
])

notification = {
  alert: "Your Insurance Information is ready.",
  category: 'insurance-info-ready',
  custom: {}
}
MedicationReadyJob.new.perform(u.device_tokens, notification)
