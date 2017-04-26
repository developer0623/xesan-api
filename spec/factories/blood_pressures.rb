FactoryGirl.define do
  factory :blood_pressure do
    user_id 99
    sequence(:systolic, 1) { |n | n }
    sequence(:diastolic, 1) { |n | n }
  end

end
