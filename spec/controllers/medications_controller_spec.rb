require 'rails_helper'

RSpec.describe MedicationsController, type: :controller do

  before do
    Medication.delete_all
    RefillInfo.delete_all
    Reminder.delete_all
    Provider.delete_all
    MedEntry.delete_all

    @user = create(:user)

    @doctor = create(:doctor)
    @pharmacy = create(:pharmacy)

    Medication.record_timestamps = false
    @medications = [
      create(:medication, user_id: @user.id, prescriber: @doctor, pharmacy: @pharmacy, created_at: Time.new(2015, 1, 1), updated_at: Time.new(2015, 1, 1)),
      create(:medication, user_id: @user.id, prescriber: @doctor, pharmacy: @pharmacy, created_at: Time.new(2015, 1, 2), updated_at: Time.new(2015, 1, 2)),
      create(:medication, user_id: @user.id, prescriber: @doctor, pharmacy: @pharmacy, created_at: Time.new(2015, 1, 3), updated_at: Time.new(2015, 1, 3))
    ]

    @medications.each do |b|
      b.save!
    end

    @med_with_refill = @medications[0]
    @refill = create(:refill_info, rx_number: 'abcd1234', active_refill: true, medication_id: @med_with_refill.id)
    @refill.save
    Medication.record_timestamps = true

    NdcPackage.setup_seed_data
  end

  describe "index" do
    it "should return all the medications" do
      login_with @user

      get :index
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq(3)
    end

    it "should support since" do
      login_with @user
      get :index, since: Time.new(2014, 12, 31), format: :json
      json = JSON.parse(response.body)
      expect(json.length).to eq(3)

      get :index, since: Time.new(2015, 1, 1), format: :json
      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
    end
  end

  describe "show" do
    it "should return a single medication" do
      login_with @user

      get :show, id: @medications[0].id
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(@medications[0].id)
    end
  end

  describe "create" do
    it "should create a medication" do
      expect(Medication.count).to eq(3)
      expect(RefillInfo.count).to eq(1)
      expect(Reminder.count).to eq(0)
      expect(MedEntry.count).to eq(0)

      login_with @user

      post :create, {
        medication: {
          "user_id"=>@user.id,
          "name"=>"Advil",
          "dose"=>"1",
          "frequency"=>"once daily",
          "strength"=>"1mg",
          "form"=>"Tablets",
          "count"=>0,
          "route"=>"By mouth",
          "category"=>"Rx Medication",
          "instructions"=>"take it",
          "ndc"=>"123-456",
          "refills_attributes" => [{
            "rx_number"=>"abc123",
            "rx_fill_date"=>"2016-01-01T05:00:00.000Z",
            "refill_num"=>1,
            "refill_total"=>3,
            "current_med_count"=>30,
            "days_supply"=>30,
            "discard_date"=>"2017-01-01T05:00:00.000Z",
            "refills_expiration"=>"2016-05-20T04:00:00.000Z",
            "active_refill"=>true
          }],
          "reminders_attributes" => [
            {
              "hour": "14",
              "minute": "30",
              "sunday": true,
              "monday": true,
              "tuesday": true,
              "wednesday": true,
              "thursday": true,
              "friday": true,
              "saturday": true,
              "med_entries_attributes" => [
                {
                  "taken": true,
                  "scheduled_time": "2017-01-01T05:00:00.000Z",
                  "actual_time": "2017-01-01T05:01:00.000Z"
                }
              ]
            },
            {
              "hour": "14",
              "minute": "30",
              "sunday": false,
              "monday": true,
              "tuesday": true,
              "wednesday": true,
              "thursday": false,
              "friday": true,
              "saturday": false
            }
          ],
          "pharmacy_id"=>1366551665,
          "prescriber_id"=>1083004337
        }
      }

      expect(response.status).to eq(201)

      json = JSON.parse(response.body)
      expect(Medication.count).to eq(4)
      expect(RefillInfo.count).to eq(2)
      expect(Reminder.count).to eq(2)
      expect(MedEntry.count).to eq(1)
      g = Medication.find_by(id: json['id'])
      expect(g.name).to eq("Advil")
      expect(g.refills.count).to eq(1)
      expect(g.active_refill).to_not be_nil
      expect(g.active_refill.refill_num).to eq(1)
      expect(g.reminders.count).to eq(2)
      expect(g.count).to eq(30)
    end
  end

  describe "batch_create" do
    it "should create multiple medications" do
      login_with @user

      expect(Medication.count).to eq(3)

      medications = build_list(:medication, 3).map do |m|
        m.attributes
      end
      post :batch_create, medications: medications, format: :json

      expect(response.status).to eq(201)
      json = JSON.parse(response.body)
      expect(Medication.count).to eq(6)
      expect(json.length).to eq(3)
      expect(json[0]['id']).to_not be_nil
    end

    it "should fail with missing params" do
      login_with @user

      expect(Medication.count).to eq(3)

      post :batch_create, format: :json

      expect(response.status).to eq(400)
      expect(Medication.count).to eq(3)
    end
  end

  describe "batch_update" do
    it "should update multiple medications" do
      login_with @user

      expect(Medication.count).to eq(3)

      medications = build_list(:medication, 3).map do |m|
        m.attributes
      end
      post :batch_create, medications: medications, format: :json

      expect(response.status).to eq(201)
      json = JSON.parse(response.body)
      expect(Medication.count).to eq(6)
      expect(json.length).to eq(3)
      expect(json[0]['id']).to_not be_nil

      meds = [
        Medication.find(json[0]['id']).attributes,
        Medication.find(json[1]['id']).attributes,
        Medication.find(json[2]['id']).attributes
      ]
      meds[0]['name'] = 'med 1'
      meds[1]['name'] = 'med 2'
      meds[2]['name'] = 'med 3'

      post :batch_update, medications: meds, format: :json
      expect(response.status).to eq(200)
      expect(Medication.count).to eq(6)
      expect(Medication.find(json[0]['id']).name).to eq("med 1")
      expect(Medication.find(json[1]['id']).name).to eq("med 2")
      expect(Medication.find(json[2]['id']).name).to eq("med 3")
    end

    it "should fail when no params sent" do
      login_with @user

      expect(Medication.count).to eq(3)

      post :batch_update, format: :json

      expect(response.status).to eq(400)
      expect(Medication.count).to eq(3)
    end

    it "should fail when invalid meds are sent" do
      login_with @user

      expect(Medication.count).to eq(3)

      post :batch_update, medications: [{ id: 'abcd1234' }], format: :json

      expect(response.status).to eq(422)
      expect(Medication.count).to eq(3)
    end
  end

  describe "batch_delete" do
    it "should delete multiple medications" do
      login_with @user

      expect(Medication.count).to eq(3)

      ids = Medication.all.map do |med|
        med.id
      end

      post :batch_delete, ids: ids, format: :json

      expect(response.status).to eq(204)
      expect(Medication.count).to eq(0)
    end

    it "should fail when no params sent" do
      login_with @user

      expect(Medication.count).to eq(3)

      post :batch_delete, format: :json

      expect(response.status).to eq(400)
      expect(Medication.count).to eq(3)
    end

    it "should fail with bogus ids" do
      login_with @user

      expect(Medication.count).to eq(3)

      post :batch_delete, ids: ['abc'], format: :json

      expect(response.status).to eq(422)
      expect(Medication.count).to eq(3)
    end
  end

  describe "destroy" do
    it "should delete a medication" do
      login_with @user

      delete :destroy, id: @medications[0].id

      expect(response.status).to eq(204)
      expect(Medication.count).to eq(2)
    end
  end

  describe "update" do
    it "should update a medication" do
      login_with @user

      expect(Medication.first.name).to eq("Tylenol")

      put :update, {id: @medications[0].id, medication: FactoryGirl.attributes_for(:medication, refills_remaining: 11)}
      expect(response.status).to eq(204)

      med = Medication.find_by(id: @medications[0].id)
      expect(med.refills_remaining).to eq(11)
    end
  end

  describe "by_refill" do
    it "should 404 when not found" do
      expect(RefillInfo.count).to eq(1)
      expect(RefillInfo.first.active_refill).to eq(true)
      login_with @user

      expect {
        get :by_refill, rx_num: 'blah', format: :json
      }.to raise_error(ActionController::RoutingError)
    end

    it "should get a med by its active refill's rx_number" do
      expect(RefillInfo.count).to eq(1)
      expect(RefillInfo.first.active_refill).to eq(true)
      login_with @user

      get :by_refill, rx_num: @refill.rx_number, user_id: @user.id, format: :json
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json['refills'][0]['id']).to eq(@refill.id)
      expect(json['refills'][0]['rxNumber']).to eq(@refill.rx_number)
    end
  end

  describe "load_info" do
    it "should take a valid fda_native_code" do
      login_with @user
      post :load_info, ndc: "0002-3228-07", format: :json
      expect(response.status).to eq(200)
      resp = JSON.parse(response.body)
      expect(resp["name"]).to eq("Strattera")
    end
    it "should also take a valid 13_letter_code" do
      login_with @user
      post :load_info, ndc: "00002-3228-07", format: :json
      expect(response.status).to eq(200)
      resp = JSON.parse(response.body)
      expect(resp["name"]).to eq("Strattera")
    end
    it "should 404 when not found" do
      login_with @user
      post :load_info, ndc: "0002-3228-00", format: :json
      expect(response.status).to eq(404)
    end
  end

  describe "verify_ndc" do
    it "should take a valid fda_native_code" do
      login_with @user
      post :verify_ndc, ndc: "0002-3228-07", format: :json
      expect(response.status).to eq(200)
    end
    it "should also take a valid 13_letter_code" do
      login_with @user
      post :verify_ndc, ndc: "00002-3228-07", format: :json
      expect(response.status).to eq(200)
    end
    it "should 404 when not found" do
      login_with @user
      post :verify_ndc, ndc: "0002-3228-00", format: :json
      expect(response.status).to eq(404)
    end
  end
end
