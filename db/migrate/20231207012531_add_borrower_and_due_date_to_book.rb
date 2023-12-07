class AddBorrowerAndDueDateToBook < ActiveRecord::Migration[7.1]
  def change
    add_reference :books, :borrower, foreign_key: true
    add_column :books, :due_date, :datetime
  end
end
