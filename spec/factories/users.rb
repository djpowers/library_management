FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    credit_card { Faker::Finance.credit_card }
  end
end
