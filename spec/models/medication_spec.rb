require 'rails_helper'

RSpec.describe Medication, type: :model do

  before do
    @provider = Provider.create(npi: '1234')
    @pharmacy = Pharmacy.create(npi: '5678', is_pharmacy: true)
  end

  describe "create" do
    it "should create" do
      expect { Medication.create!(prescriber: @provider, pharmacy: @pharmacy) }.not_to raise_error
    end
  end

  describe "as_json" do
    it "should render" do
      @med = create(:medication)
      @json = @med.as_json
      expect(@json[:count]).to eq(30)
    end
  end

end
