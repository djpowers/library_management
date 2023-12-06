require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe "POST /" do
    it "creates a book and adds it to a library" do
      library = FactoryBot.create(:library)
      book = FactoryBot.build(:book, library: library)
      
      expect {
        post library_books_path(
          book.library.id,
          book: {
            isbn: book.isbn,
            title: book.title,
            author: book.author,
          }
        )
      }.to change(Book, :count).by(1)
      expect(library.books.length).to eq(1)
    end
  end
end
