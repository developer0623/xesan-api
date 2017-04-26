require 'rails_helper'

RSpec.describe Temperature, type: :model do
  before do
    @user = create(:user)
  end

  describe "create" do
    it "should create" do
      expect { Temperature.create!(temperature: 97, user_id: @user.id) }.not_to raise_error
    end
  end
end
