module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    before_filter :validate_account_update_params, :only => :update

    def sign_up_params
      params.permit(:email, :first_name, :last_name, :height, :weight, :gender, :dob, :password, :password_confirmation, :device_tokens => [])
    end

    def account_update_params
      params.permit(:first_name, :last_name, :height, :weight, :gender, :dob,
        :password, :password_confirmation,
        :home_address_attributes => [:id, :street, :street2, :city, :state, :zip, :type],
        :mailing_address_attributes => [:id, :street, :street2, :city, :state, :zip, :type],
        :insurance_attributes => [:company_name, :street_address, :city, :state, :zip, :plan_code, :id_number, :group_number, :rx_bin, :rx_pcn, :rx_group, :coverage, :office_copay, :specialist_copay, :annual_deductible, :deductible_effective_date, :member_servies_phone, :provider_services_phone, :pharmacist_services_phone, :nurse_line_phone, :website],
        :device_tokens => [])
    end
  end
end
