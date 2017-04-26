# I'm not sure how to test this file, so skipping it for now.

# require 'rails_helper'

# RSpec.describe ApiController, type: :controller do

#   before do
#     BloodPressure.delete_all
#     @user = create(:user)

#     @blood_pressures = build_list(:blood_pressure, 3, user_id: @user.id)
#     @blood_pressures.each do |b|
#       b.save!
#     end
#   end

#   describe "require_auth" do
#     it "should block unauthorized users" do

#       get :show, id: @blood_pressures[0].id
#       expect(response.status).to eq(401)

#     end
#   end
# end
