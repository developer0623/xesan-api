require 'rails_helper'

RSpec.describe PulseOxygen, type: :model do
  before do
    @user = create(:user)
  end

  describe "create" do
    it "should create" do
      expect { PulseOxygen.create!(pulse_oxygen: 87, user_id: @user.id) }.not_to raise_error
    end
  end
end
