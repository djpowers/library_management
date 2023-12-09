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
      expect(books.length).to eq(1)
      expect(books.first["title"]).to eq(desired_book.title)
    end

    it "returns title, and availability or due date" do
      library = FactoryBot.create(:library)
      desired_book = FactoryBot.create(:book, isbn: "1234", title: "My Great American Novel", author: "Jane Doe", library:)

      get library_books_path(
        desired_book.library.id,
        query: 'Great'
      )

      expect(JSON.parse(response.body)).to eq(
        [
          {
            "isbn" => "1234",
            "title" => "My Great American Novel",
            "author" => "Jane Doe",
            "available" => true,
            "due_back" => nil
          }
        ]
      )
    end

    context "with multiple copies of a book" do
      it "returns only one copy of each (available, or due back earliest)" do
        library = FactoryBot.create(:library)
        FactoryBot.create(:book, :overdue, isbn: "1234", title: "My Great American Novel", author: "Jane Doe", library:)
        FactoryBot.create(:book, isbn: "1234", title: "My Great American Novel", author: "Jane Doe", library:)

        FactoryBot.create(:book, :overdue, isbn: "5678", title: "The Next Great American Novel", author: "Jane Doe", library:, due_date: 2.hours.from_now)
        FactoryBot.create(:book, :overdue, isbn: "5678", title: "The Next Great American Novel", author: "Jane Doe", library:, due_date: 2.days.from_now)

        get library_books_path(
          library.id,
          query: 'Great'
        )

        books = JSON.parse(response.body)
        expect(books.length).to eq(2)
        expect(books.first["available"]).to be(true)
        expect(books.second["due_back"]).to be_present
      end
    end

    context "with multiple libraries" do
      library1 = FactoryBot.create(:library)
      library2 = FactoryBot.create(:library)

      FactoryBot.create(:book, isbn: "1234", title: "My Great American Novel", author: "Jane Doe", library: library1)
      FactoryBot.create(:book, isbn: "5678", title: "The Next Great American Novel", author: "Jane Doe", library: library2)

      it "scopes search to a single library" do
        get library_books_path(
          library1.id,
          query: 'Great'
        )

        books = JSON.parse(response.body)
        expect(books.length).to eq(1)
      end

      context "with a global search flag included" do
        it "returns books across libraries" do
          get library_books_path(
            library1.id,
            query: 'Great',
            global: true
          )

          books = JSON.parse(response.body)
          expect(books.length).to eq(2)
          expect(books.first["library_id"]).to be_present
          expect(books.second["library_id"]).to be_present
        end
      end
    end
  end
end
