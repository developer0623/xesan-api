# FactoryGirl.define do
#   sequence :email do |n|
#     "person#{n}@example.com"
#   end
# end

FactoryGirl.define do
  factory :admin_user, :class => 'User' do
    uid 'admjn@xensan.com'
    email 'admin@xensan.com'
    provider 'email'

    first_name 'Bob'
    last_name 'Smith'
    password '12345678'
    password_confirmation '12345678'
    is_admin true
  end
end

FactoryGirl.define do
  factory :provider_user, :class => 'User' do
    uid 'provider@xensan.com'
    email 'provider@xensan.com'
    provider 'email'

    first_name 'Dr. Bob'
    last_name 'Smith'
    password '12345678'
    password_confirmation '12345678'
  end
end

FactoryGirl.define do
  factory :user, :class => 'User' do
    uid 'user@xensan.com'
    email 'user@xensan.com'
    provider 'email'

    first_name 'Jim'
    last_name 'Bob'
    password '12345678'
    password_confirmation '12345678'
  end
end
