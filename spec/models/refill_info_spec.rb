require 'rails_helper'

RSpec.describe RefillInfo, type: :model do
  before do
    @user = create(:user)
  end

  describe "create" do
    it "should create" do
      expect { RefillInfo.create!(medication_id: 4) }.not_to raise_error
    end
  end
end
