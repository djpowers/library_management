FactoryBot.define do
  factory :book do
    isbn { Faker::Barcode.isbn }
    title { Faker::Book.title }
    author { Faker::Book.author }
    library
  end
end
