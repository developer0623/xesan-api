require 'rails_helper'

RSpec.describe Glucose, type: :model do

  before do
    @user = create(:user)
  end

  describe "create" do
    it "should create" do
      expect { Glucose.create!(value: 66, activities: [ 'HIKING', 'pre-meal' ], notes: 'enjoying the mountains', user: @user, created_at: Time.now) }.not_to raise_error
    end

    it "should have defaults" do
      g = Glucose.create!
      expect(g.activities).to eq([])
      expect(g.is_control).to eq(false)
    end

    it "should render the json view properly" do
      g = create(:glucose)
      g.save!

      json = g.as_json

      expect(json[:createdAt]).to_not be_nil
      expect(json[:isControl]).to eq(false)
    end
  end
end
