require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before do
    User.delete_all
    @user = create(:user, email: "test@rspec.com")
  end

  describe "is_email_unique" do
    it "should return true if user exists" do
      get "is_email_unique", {:email => 'test@rspec.com'}
      json = JSON.parse(response.body)
      expect(json['valid']).to eq(false)
    end

    it "should return false if user doesn't exist" do
      get "is_email_unique", {:email => 'new@email.com'}
      json = JSON.parse(response.body)
      expect(json['valid']).to eq(true)
    end
  end

end
