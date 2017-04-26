require 'rails_helper'

RSpec.describe TemperaturesController, type: :controller do

  before do
    Temperature.delete_all
    @user = create(:user)

    Temperature.record_timestamps = false
    @temperatures = [
      create(:temperature, user_id: @user.id, created_at: Time.new(2015, 1, 1)),
      create(:temperature, user_id: @user.id, created_at: Time.new(2015, 1, 2)),
      create(:temperature, user_id: @user.id, created_at: Time.new(2015, 1, 3))
    ]
    @temperatures.each do |b|
      b.save!
    end
    Temperature.record_timestamps = true
  end

  describe "index" do
    it "should return all the temperature readings" do
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
    it "should create a temperature vital" do
      login_with @user

      post :create, {
        temperature: {
          temperature: 90
        }
      }

      expect(response.status).to eq(201)

      json = JSON.parse(response.body)

      expect(Temperature.count).to eq(4)
      g = Temperature.find_by(id: json['id'])
      expect(g.temperature).to eq(90)
    end
  end

  describe "batch_create" do
    it "should create multiple temperature vitals" do
      login_with @user

      expect(Temperature.count).to eq(3)

      temperatures = build_list(:temperature, 3).map do |temp|
        temp.attributes
      end
      post :batch_create, temperatures: temperatures, format: :json

      expect(response.status).to eq(201)

      json = JSON.parse(response.body)

      expect(Temperature.count).to eq(6)
      expect(json.length).to eq(3)
      expect(json[0]['id']).to_not be_nil
    end
  end
end
