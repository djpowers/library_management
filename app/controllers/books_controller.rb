class BooksController < ApplicationController
  before_action :get_library

  def create
    @book = @library.books.build(book_params)

    if @book.save
      @book = Book.create(book_params)
    end
  end

  def update
    @book = Book.find(params[:id] || params[:book_id])
    @borrower = Borrower.find(params[:borrower_id])

    if params[:return] == true
      @book.update(library: @library, due_date: nil, borrower_id: nil)
    elsif @borrower.books.overdue.present?
      render status: :unprocessable_entity
    else
      @book.update(due_date: 1.week.from_now, borrower_id: @borrower.id)
    end
  end

  def index
    @books = Book.where(library: @library).where("title ILIKE ?", "%#{params[:query]}%")

    books_by_isbn = @books.group_by { |book| book[:isbn] }

    filtered_books = books_by_isbn.map do |isbn, books|
      if books.length >= 2
        available = books.filter{ |book| book.due_date.nil? }
        unavailable = books.filter{ |book| book.due_date.present? }

        if available.present?
          available.first
        elsif unavailable.present?
          unavailable
            .sort { |book_a, book_b| book_a.due_date - book_b.due_date }
            .first
        end
      else
        books.first
      end
    end

    books_data = filtered_books.map do |book|
      {
        isbn: book.isbn,
        title: book.title,
        author: book.author,
        available: book.due_date.nil?,
        due_back: book.due_date.present? ? book.due_date : nil
      }
    end

    render json: books_data
  end

  private

  def get_library
    @library = Library.find(params[:library_id])
  end

  def book_params
    params.require(:book).permit(:isbn, :author, :title)
  end
end
