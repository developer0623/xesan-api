require 'rails_helper'

RSpec.describe BloodPressure, type: :model do

  before do
    @user = create(:user)
  end

  describe "create" do
    it "should create" do
      expect { BloodPressure.create!(systolic: 120, diastolic: 90, user_id: @user.id) }.not_to raise_error
    end
  end
end
