class CreateInsurances < ActiveRecord::Migration
  def change
    create_table :insurances do |t|
      t.belongs_to :user, index: true

      t.string :company_name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip

      t.string :plan_code
      t.string :id_number
      t.string :group_number
      t.string :rx_bin
      t.string :rx_pcn
      t.string :rx_group

      t.string :coverage

      t.float :office_copay
      t.float :specialist_copay
      t.float :annual_deductible

      t.date :deductible_effective_date

      t.string :member_servies_phone
      t.string :provider_services_phone
      t.string :pharmacist_services_phone
      t.string :nurse_line_phone

      t.string :website

      t.timestamps null: false
    end
  end
end
