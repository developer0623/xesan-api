require 'rails_helper'

RSpec.describe GlucoseStripBottleController, type: :controller do

  before do
    User.delete_all
    GlucoseStripBottle.delete_all

    @user = create(:user)
    @gsb = create(:glucose_strip_bottle)

    @user.glucose_strip_bottles << @gsb
  end

  describe "POST #create" do
    it "returns http success" do
      login_with @user
      post :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "decrement_strip_count" do
    it "should decrement" do
      expect(GlucoseStripBottle.count).to eq(1)
      expect(GlucoseStripBottle.first.strip_count).to eq(50)

      login_with @user
      post :decrement_strip_count

      expect(response.status).to eq(200)

      expect(GlucoseStripBottle.count).to eq(1)
      expect(GlucoseStripBottle.first.strip_count).to eq(49)
    end
  end

end
