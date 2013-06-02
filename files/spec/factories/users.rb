# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do

  factory :user do
    
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password "letmein123"
    email { "#{first_name}.#{last_name}@example.com" }
    
    factory :admin do
        after(:create) {|user| user.add_role(:admin)}
    end
    
  end

end
