class BorrowersController < ApplicationController
  def create
    library = Library.find(params[:library_id])
    user = User.find(params[:user_id])

    Borrower.create(library:, user:)
  end
end
