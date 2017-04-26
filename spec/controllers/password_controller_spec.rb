require 'rails_helper'

RSpec.describe PasswordController, type: :controller do

  before do
  end

  describe "reset" do
    it "should be OK" do
      #only token client_id matter here
      get :reset, {:token => 1, :client_id => 1}
      expect(response.status).to eq(200)
    end

    it "should fail when missing token" do
      expect{ get :reset, {:client_id => 1} }.to raise_error(ActionController::ParameterMissing)
    end
  end
end
