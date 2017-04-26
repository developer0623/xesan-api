FactoryGirl.define do
  factory :pharmacy do
    sequence(:npi, 1111) { |n | n }
    is_pharmacy true
    organization_name "cvs"
  end
end
