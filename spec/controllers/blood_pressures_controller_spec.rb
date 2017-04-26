require 'rails_helper'

RSpec.describe BloodPressuresController, type: :controller do

  before do
    BloodPressure.delete_all
    @user = create(:user)

    BloodPressure.record_timestamps = false
    @blood_pressures = [
      create(:blood_pressure, user: @user, created_at: Time.new(2015, 1, 1)),
      create(:blood_pressure, user: @user, created_at: Time.new(2015, 1, 2)),
      create(:blood_pressure, user: @user, created_at: Time.new(2015, 1, 3))
    ]
    @blood_pressures.each do |b|
      b.save!
    end
    BloodPressure.record_timestamps = true
  end

  describe "index" do

    it "should return all the blood pressure readings" do
      login_with @user

      get :index
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq(3)

      # test the json render
      expect(json[0]['createdAt']).not_to be(nil)
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

    it "should return no results when none exist" do
      BloodPressure.delete_all
      login_with @user
      get :index
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq(0)
    end
  end

  describe "create" do
    it "should create a blood pressure vital" do
      login_with @user

      post :create, {
        blood_pressure: {
          systolic: 120,
          diastolic: 90
        }
      }

      expect(response.status).to eq(201)

      json = JSON.parse(response.body)

      expect(BloodPressure.count).to eq(4)
      g = BloodPressure.find_by(id: json['id'])
      expect(g.systolic).to eq(120)
      expect(g.diastolic).to eq(90)
    end
  end

  describe "batch_create" do
    it "should create multiple blood pressure vitals" do
      login_with @user

      expect(BloodPressure.count).to eq(3)

      blood_pressures = build_list(:blood_pressure, 3).map do |bp|
        bp.attributes
      end

      post :batch_create, blood_pressures: blood_pressures, format: :json

      expect(response.status).to eq(201)

      json = JSON.parse(response.body)

      expect(BloodPressure.count).to eq(6)
      expect(json.length).to eq(3)
      expect(json[0]['id']).to_not be_nil

      # it should retain order
      (0..2).each do |i|
        expect(json[i]['systolic']).to eq(blood_pressures[i][:systolic])
        expect(json[i]['diastolic']).to eq(blood_pressures[i][:diastolic])
      end
    end

    it "should not work with bogus values" do
      login_with @user

      expect(BloodPressure.count).to eq(3)

      blood_pressure = {
        user_id: 99,
        systolic: 1,
        diastolic: 1,
        stuff: 'hi'
      }
      post :batch_create, blood_pressures: [blood_pressure], format: :json

      expect(response.status).to eq(400)
    end

    it "should work like this" do
      BloodPressure.record_timestamps = false
      login_with @user

      expect(BloodPressure.count).to eq(3)

      blood_pressures = [{"systolic"=>100, "diastolic"=>79, "created_at"=>"2015-09-01T03:27:12.661Z"}, {"systolic"=>100, "diastolic"=>80, "created_at"=>"2015-09-01T03:30:37.408Z"}, {"systolic"=>66, "diastolic"=>43, "created_at"=>"2015-09-01T03:31:07.266Z"}, {"systolic"=>11, "diastolic"=>22, "created_at"=>"2015-09-01T13:25:55.221Z"}, {"systolic"=>44, "diastolic"=>33, "created_at"=>"2015-09-01T13:26:28.419Z"}, {"systolic"=>88, "diastolic"=>77, "created_at"=>"2015-09-01T13:32:03.507Z"}, {"systolic"=>66, "diastolic"=>44, "created_at"=>"2015-09-01T13:35:19.128Z"}, {"systolic"=>47, "diastolic"=>23, "created_at"=>"2015-09-01T13:39:32.540Z"}, {"systolic"=>97, "diastolic"=>46, "created_at"=>"2015-09-01T13:42:03.971Z"}]
      post :batch_create, blood_pressures: blood_pressures, format: :json

      expect(BloodPressure.count).to eq(12)
      expect(response.status).to eq(201)
      BloodPressure.record_timestamps = true
    end
  end
end
