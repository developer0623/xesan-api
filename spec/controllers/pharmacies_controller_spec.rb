require 'rails_helper'

RSpec.describe PharmaciesController, type: :controller do

  before do
    Pharmacy.delete_all
    @user = create(:user)

    @user.providers.delete_all

    @pharmacies = build_list(:pharmacy, 3)
    @pharmacies.each do |b|
      b.save!
    end
  end
end
