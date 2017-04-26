FactoryGirl.define do
  factory :refill_info do
    rx_number '999'
    rx_fill_date Date.today
    refill_num 12
    refill_total 24
    days_supply 30
    current_med_count 30
    discard_date Date.today + 90.days
    refills_expiration Date.today + 1.year
  end

end
