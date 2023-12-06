class BooksController < ApplicationController
  def create
    @library = Library.find(params[:library_id])
    @book = @library.books.build(book_params)

    if @book.save
      @book = Book.create(book_params)
    end
  end

  private

  def book_params
    params.require(:book).permit(:isbn, :author, :title)
  end
end
