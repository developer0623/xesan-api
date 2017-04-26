require 'rails_helper'

RSpec.describe GlucosesController, type: :controller do

  before do
    Glucose.delete_all
    @user = create(:user)
    @user.save!

    @glucoses = [
      create(:glucose, user: @user, created_at: Time.new(2015, 1, 1)),
      create(:glucose, user: @user, created_at: Time.new(2015, 1, 2)),
      create(:glucose, user: @user, created_at: Time.new(2015, 1, 3))
    ]
    @glucoses.each do |g|
      g.save!
    end
  end


  describe "index" do
    it "should return all the glucose readings" do
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
    it "should create a glucose vital" do
      login_with @user

      now = Time.now
      post :create, {
        glucose: {
          value: 65,
          notes: 'my notes',
          activities: ['SPELUNKING', 'pre-meal'],
          created_at: now,
          is_control: true
        }
      }

      expect(response.status).to eq(201)

      json = JSON.parse(response.body)

      expect(Glucose.count).to eq(4)
      g = Glucose.find_by(id: json['id'])
      expect(g.value).to eq(65)
      expect(g.notes).to eq('my notes')
      expect(g.activities).to eq(['SPELUNKING', 'pre-meal'])
      expect(g.created_at.to_s).to eq(now.utc.to_s)
      expect(g.is_control).to eq(true)
    end

    it "should create a glucose vital with default values" do
      login_with @user

      now = Time.now
      post :create, {
        glucose: {
          value: 65,
          notes: 'my notes',
          created_at: now
        }
      }

      expect(response.status).to eq(201)

      json = JSON.parse(response.body)

      expect(Glucose.count).to eq(4)
      g = Glucose.find_by(id: json['id'])
      expect(g.value).to eq(65)
      expect(g.notes).to eq('my notes')
      expect(g.activities).to eq([])
      expect(g.created_at.to_s).to eq(now.utc.to_s)
      expect(g.is_control).to eq(false)
    end
  end

  describe "batch_create" do
    it "should create multiple glucose vitals" do
      login_with @user

      expect(Glucose.count).to eq(3)

      now = Time.now
      glucoses = build_list(:glucose, 3, user: @user).map do |g|
        g.attributes
      end

      post :batch_create, glucoses: glucoses, format: :json

      expect(response.status).to eq(201)

      json = JSON.parse(response.body)

      expect(Glucose.count).to eq(6)
      expect(json.length).to eq(3)
      expect(json[0]['id']).to_not be_nil
    end

    it "should do this" do
      login_with @user

      expect(Glucose.count).to eq(3)
      glucoses = [{"value"=>125, "activities"=>["exercise"], "notes"=>nil, "is_control"=>"false", "created_at"=>"2015-09-03T03:13:50.463Z"}, {"value"=>125, "activities"=>["exercise"], "notes"=>nil, "is_control"=>"false", "created_at"=>"2015-09-03T03:19:09.423Z"}]
      post :batch_create, glucoses: glucoses, format: :json
      expect(response.status).to eq(201)
      expect(Glucose.count).to eq(5)
    end
  end
end
