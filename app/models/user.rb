class User < ApplicationRecord
  has_many :borrowers
  has_many :libraries, through: :borrowers
end
