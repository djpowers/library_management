class CreateBorrowers < ActiveRecord::Migration[7.1]
  def change
    create_table :borrowers do |t|
      t.references :library, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
