class Borrower < ApplicationRecord
  belongs_to :library
  belongs_to :user

  has_many :books
end
