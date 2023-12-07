class BooksController < ApplicationController
  def create
    @library = Library.find(params[:library_id])
    @book = @library.books.build(book_params)

    if @book.save
      @book = Book.create(book_params)
    end
  end

  def update
    @book = Book.find(params[:id])
    @borrower = Borrower.find(params[:borrower_id])
    @book.update(due_date: 1.week.from_now, borrower_id: @borrower.id)
  end

  private

  def book_params
    params.require(:book).permit(:isbn, :author, :title)
  end
end
