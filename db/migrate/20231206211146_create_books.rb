class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :isbn
      t.string :title
      t.string :author
      t.references :library, null: false, foreign_key: true

      t.timestamps
    end
  end
end
