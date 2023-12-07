class Borrower < ApplicationRecord
  belongs_to :library
  belongs_to :user
end
