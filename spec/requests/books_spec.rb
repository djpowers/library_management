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

    it "rejects book lending if borrower has overdue books" do
      late_book = FactoryBot.create(:book, :overdue)
      book = FactoryBot.create(:book)

      patch library_book_path(
        book.library.id,
        book.id,
        borrower_id: late_book.borrower.id
      )

      expect(response.code).to eq("422")
      expect(book.reload.due_date).to be_nil
      expect(book.reload.borrower).to be_nil
    end
  end

  describe "PATCH /libraries/:library_id/books/:book_id/return" do
    it "returns a book to a different library and updates lending details" do
      borrower = FactoryBot.create(:borrower)
      return_library = FactoryBot.create(:library, name: "A Different Library")

      book = FactoryBot.create(:book, :overdue)

      patch library_book_return_path(
        return_library.id,
        book.id,
        borrower_id: borrower.id
      )

      expect(book.reload.due_date).to be_nil
      expect(book.reload.borrower).to be_nil
      expect(book.library).to eq(return_library)
    end
  end

  describe "GET /libraries/:library_id/books" do
    it "returns books whose titles partially match search query" do
      library = FactoryBot.create(:library)
      desired_book = FactoryBot.create(:book, title: "My Great American Novel", library:)
      other_book = FactoryBot.create(:book, title: "A Less Compelling Book", library:)

      get library_books_path(
        desired_book.library.id,
        query: 'Great'
      )

      books = JSON.parse(response.body)
      expect(books).to include(JSON.parse(desired_book.to_json))
    end
  end
end
