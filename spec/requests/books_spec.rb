require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe "POST /libraries/:library_id/books" do
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

  describe "PATCH /libraries/:library_id/books/:book_id" do
    it "updates a book with lending details" do
      borrower = FactoryBot.create(:borrower)
      library = borrower.library

      book = FactoryBot.create(:book)

      patch library_book_path(
        library.id,
        book.id,
        borrower_id: borrower.id
      )

      expect(book.reload.due_date).to be_present
      expect(book.reload.borrower).to eq(borrower)
    end
  end
end
