FactoryGirl.define do
  sequence :npi do |n|
    n
  end
end

FactoryGirl.define do
  factory :doctor do
    sequence(:npi, 4444) { |n | n }
    is_pharmacy false
    first_name "Bob"
    last_name "Baker"
  end
end
