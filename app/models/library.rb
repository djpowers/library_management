class Library < ApplicationRecord
  has_many :books
  has_many :borrowers
  has_many :users, through: :borrowers
end
