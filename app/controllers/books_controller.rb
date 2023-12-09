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
    render json: @books
  end

  private

  def get_library
    @library = Library.find(params[:library_id])
  end

  def book_params
    params.require(:book).permit(:isbn, :author, :title)
  end
end
