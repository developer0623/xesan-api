require 'rails_helper'

RSpec.describe WeightsController, type: :controller do

  before do
    Weight.delete_all
    @user = create(:user)

    Weight.record_timestamps = false
    @weights = [
      create(:weight, user_id: @user.id, created_at: Time.new(2015, 1, 1)),
      create(:weight, user_id: @user.id, created_at: Time.new(2015, 1, 2)),
      create(:weight, user_id: @user.id, created_at: Time.new(2015, 1, 3))
    ]
    @weights.each do |b|
      b.save!
    end
    Weight.record_timestamps = true
  end

  describe "index" do

    it "should return all the weight readings" do
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
    it "should create a weight vital" do
      login_with @user

      post :create, {
        weight: {
          weight: 90
        }
      }

      expect(response.status).to eq(201)

      json = JSON.parse(response.body)

      expect(Weight.count).to eq(4)
      g = Weight.find_by(id: json['id'])
      expect(g.weight).to eq(90)
    end
  end

  describe "batch_create" do
    it "should create multiple weight vitals" do
      login_with @user

      expect(Weight.count).to eq(3)

      weights = build_list(:weight, 3).map do |weight|
        weight.attributes
      end
      post :batch_create, weights: weights, format: :json

      expect(response.status).to eq(201)

      json = JSON.parse(response.body)

      expect(Weight.count).to eq(6)
      expect(json.length).to eq(3)
      expect(json[0]['id']).to_not be_nil
    end
  end
end
