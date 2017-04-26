# require 'rails_helper'

# RSpec.describe RefillInfosController, type: :controller do

#   describe "index" do
#     before do
#       @med = create(:medication)
#       RefillInfo.delete_all
#       @user = create(:user)

#       @refill_infos = build_list(:refill_info, 3, medication: @med)
#       @refill_infos.each do |b|
#         b.save!
#       end
#     end

#     it "should return all the refill infos" do
#       login_with @user

#       get :index, medication_id: @med.id
#       expect(response.status).to eq(200)
#       json = JSON.parse(response.body)
#       expect(json.length).to eq(3)

#       # test the json render
#       expect(json[0]['id']).not_to be_nil
#       expect(json[0]['rxNumber']).not_to be_nil
#       expect(json[0]['fillDate']).not_to be_nil
#       expect(json[0]['number']).not_to be_nil
#       expect(json[0]['total']).not_to be_nil
#       expect(json[0]['daysSupply']).not_to be_nil
#       expect(json[0]['discardDate']).not_to be_nil
#       expect(json[0]['expiration']).not_to be_nil
#     end

#     it "should create a refill info" do
#       login_with @user

#       post :create, {
#         refill_info: {
#           medication_id: @med.id,
#           current_med_count: 5
#         }
#       }

#       expect(response.status).to eq(201)

#       json = JSON.parse(response.body)

#       expect(RefillInfo.count).to eq(4)
#       g = RefillInfo.find_by(id: json['id'])
#       expect(g.medication_id).to eq(@med.id)
#     end

#     it "should make the new refill info the active one" do
#       login_with @user

#       @medication = Medication.create
#       post :create, {
#         refill_info: {
#           medication_id: @medication.id,
#           current_med_count: 5
#         }
#       }
#       expect(response.status).to eq(201)

#       json = JSON.parse(response.body)

#       expect(RefillInfo.count).to eq(4)
#       g = RefillInfo.find_by(id: json['id'])
#       expect(Medication.find_by(id: @medication.id).refills.count).to eq(1)
#       expect(Medication.find_by(id: @medication.id).active_refill.id).to eq(json['id'])
#       expect(g.medication_id).to eq(@medication.id)

#       post :create, {
#         refill_info: {
#           medication_id: @medication.id,
#           current_med_count: 5
#         }
#       }
#       expect(response.status).to eq(201)

#       json = JSON.parse(response.body)

#       expect(RefillInfo.count).to eq(5)
#       g = RefillInfo.find_by(id: json['id'])
#       expect(g.medication_id).to eq(@medication.id)
#       expect(g.active_refill).to eq(true)
#       expect(Medication.find_by(id: @medication.id).refills.count).to eq(2)
#       expect(Medication.find_by(id: @medication.id).refills.where(active_refill: true).count).to eq(1)
#       expect(Medication.find_by(id: @medication.id).active_refill.id).to eq(json['id'])
#     end

#   end
# end
