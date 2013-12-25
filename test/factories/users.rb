
FactoryGirl.define do
  factory :user do
    first_name 'first'
    last_name 'last'
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password 'please12'
    password_confirmation 'please12'
    confirmed_at { Time.now }
    plans { [FactoryGirl.build( :plan )] }
  end
end
