FactoryGirl.define do
  factory :glucose do
    sequence(:value, 65) { |n | n }
    sequence(:created_at, 1) { |n| Time.new(2015, 1, n) }
    activities [ "EXERCISE", "pre-meal" ]
    notes "No notes"
  end

end
