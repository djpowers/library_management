class Book < ApplicationRecord
  belongs_to :library
  belongs_to :borrower, optional: true
end
