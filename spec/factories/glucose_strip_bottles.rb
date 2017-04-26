FactoryGirl.define do
  factory :glucose_strip_bottle do
    strip_count 50
    expiration "2015-11-29"
    opened "2015-11-29"
    lot_number "123-45"
    current true
  end

end
