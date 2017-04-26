require 'rails_helper'

RSpec.describe PulseOxygensController, type: :controller do

  before do
    PulseOxygen.delete_all
    @user = create(:user)

    PulseOxygen.record_timestamps = false
    @pulse_oxygens = [
      create(:pulse_oxygen, user_id: @user.id, created_at: Time.new(2015, 1, 1)),
      create(:pulse_oxygen, user_id: @user.id, created_at: Time.new(2015, 1, 2)),
      create(:pulse_oxygen, user_id: @user.id, created_at: Time.new(2015, 1, 3))
    ]
    @pulse_oxygens.each do |b|
      b.save!
    end
    PulseOxygen.record_timestamps = true
  end



  describe "index" do

    it "should return all the pulse oxygen readings" do
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

  end

  describe "create" do
    it "should create a pulse oxygen vital" do
      login_with @user

      post :create, {
        pulse_oxygen: {
          pulse_oxygen: 90
        }
      }

      expect(response.status).to eq(201)

      json = JSON.parse(response.body)

      expect(PulseOxygen.count).to eq(4)
      g = PulseOxygen.find_by(id: json['id'])
      expect(g.pulse_oxygen).to eq(90)
    end
  end

  describe "batch_create" do
    it "should create multiple pulse oxygen vitals" do
      login_with @user

      expect(PulseOxygen.count).to eq(3)

      pulse_oxygens = build_list(:pulse_oxygen, 3).map do |po|
        po.attributes
      end
      post :batch_create, pulse_oxygens: pulse_oxygens, format: :json

      expect(response.status).to eq(201)

      json = JSON.parse(response.body)

      expect(PulseOxygen.count).to eq(6)
      expect(json.length).to eq(3)
      expect(json[0]['id']).to_not be_nil
    end
  end
end
