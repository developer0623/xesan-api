require 'rails_helper'

RSpec.describe Weight, type: :model do
  before do
    @user = create(:user)
  end

  describe "create" do
    it "should create" do
      expect { Weight.create!(weight: 97, user_id: @user.id) }.not_to raise_error
    end
  end
end
