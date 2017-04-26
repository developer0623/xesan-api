require 'rails_helper'

RSpec.describe Overrides::RegistrationsController, type: :request do

  before do
    User.delete_all
    Address.delete_all

    @user = create(:user)
    @user.save!
    @auth_headers  = @user.create_new_auth_token
  end

  describe "update_device_tokens" do
    it "should update device tokens" do

      expect(User.first.device_tokens.count).to eq(0)

      put "/v1/auth", {
        device_tokens:  ['abcd123']
      }, @auth_headers
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(User.first.device_tokens.count).to eq(1)
      expect(User.first.device_tokens[0]).to eq('abcd123')
    end
  end

  describe "create" do
    it "should create a user" do
      expect(User.count).to eq(1)
      expect(Address.count).to eq(0)

      put "/v1/auth", {
        device_tokens:  ['abcd123'],
        first_name: 'BobbyJo',
        home_address_attributes: {
          street: '123 1st Street',
          street2: 'suite 3d',
          city: 'Blahsville',
          state: 'Alabama',
          zip: '012345'
        },
        blah: '123',
        mailing_address_attributes: {
          street: '123 1st Street',
          street2: 'suite 3f',
          city: 'Blahsville',
          state: 'Alabama',
          zip: '012345'
        }
      }, @auth_headers

      expect(response.status).to eq(200)

      json = JSON.parse(response.body)
      expect(User.count).to eq(1)

      user = User.first
      expect(user.first_name).to eq('BobbyJo')

      expect(Address.count).to eq(2)
      expect(HomeAddress.count).to eq(1)
      expect(MailingAddress.count).to eq(1)

      expect(user.home_address.street).to eq('123 1st Street')
      expect(user.home_address.street2).to eq('suite 3d')
      expect(user.home_address.city).to eq('Blahsville')
      expect(user.home_address.state).to eq('Alabama')
      expect(user.home_address.zip).to eq('012345')

      expect(user.mailing_address.street).to eq('123 1st Street')
      expect(user.mailing_address.street2).to eq('suite 3f')
      expect(user.mailing_address.city).to eq('Blahsville')
      expect(user.mailing_address.state).to eq('Alabama')
      expect(user.mailing_address.zip).to eq('012345')

    end
  end

end
