FactoryGirl.define do
  factory :medication do
    user_id 99
    name "Tylenol"
    dose "30mg"
    frequency "once daily"
    strength "10%"
    count 30
    refills_remaining 12
    discard_date "1/1/2016"
    reason_for_taking "headache"
  end
end
