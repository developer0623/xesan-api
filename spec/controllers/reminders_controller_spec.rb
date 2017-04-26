require 'rails_helper'

RSpec.describe RemindersController, type: :controller do

  before do
    Reminder.delete_all
    @user = create(:user)

    @reminders = build_list(:reminder, 3)
    @reminders.each do |b|
      b.save!
    end
  end

  # describe "get reminders" do
  #   it "should return reminders associated with a medication" do
  #     login_with @user

  #     get :get_medication_reminders, {medication_id: 4}

  #     json = JSON.parse(response.body)
  #     expect(json.length).to eq(3)
  #   end
  # end

  describe "index" do
    it "should return all the reminders for a day of week" do
      login_with @user

      get :index, {day: "Monday"}
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq(0)
    end
  end

  describe "create" do
    it "should create a reminder" do
      login_with @user

      post :create, {
        reminder: {
          medication_id: 91,
          sunday: false,
          monday: true,
          tuesday: false,
          wednesday: true,
          thursday: false,
          friday: false,
          saturday: false,
          hour: "14",
          minute: "30"
        }
      }

      expect(response.status).to eq(201)

      json = JSON.parse(response.body)

      expect(Reminder.count).to eq(4)
    end
  end

  describe "show" do
    it "should return a single reminder" do
      login_with @user

      get :show, id: @reminders[0].id
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(@reminders[0].id)
    end
  end


end
