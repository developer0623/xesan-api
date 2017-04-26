require 'rails_helper'

RSpec.describe Reminder, type: :model do
  describe "create" do
    it "should create" do
      expect { Reminder.create!(medication_id: 4) }.not_to raise_error
    end
  end
end
