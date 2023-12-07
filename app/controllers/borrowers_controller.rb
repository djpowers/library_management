class BorrowersController < ApplicationController
  def create
    library = Library.find(params[:library_id])
    user = User.find_or_create_by(user_params)

    Borrower.create(library:, user:)
  end

  private

  def user_params
    params.require(:user).permit(:name, :credit_card)
  end
end
