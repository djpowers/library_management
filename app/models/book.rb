class Book < ApplicationRecord
  belongs_to :library
  belongs_to :borrower, optional: true

  scope :overdue, -> { where("due_date < ?", DateTime.now) }
end
