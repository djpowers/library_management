FactoryBot.define do
  factory :book do
    isbn { Faker::Barcode.isbn }
    title { Faker::Book.title }
    author { Faker::Book.author }
    library

    trait :overdue do
      due_date { 1.week.ago }
      borrower
    end
  end
end
