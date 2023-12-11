require 'rails_helper'

RSpec.describe "Borrowers", type: :request do
  describe "POST /libraries/:library_id/borrowers" do
    it "creates a new user and borrower relationship" do
      library = FactoryBot.create(:library)
      user = FactoryBot.build(:user)

      expect {
        post library_borrowers_path(
          library.id,
          user: user.attributes
        )
      }.to change(Borrower, :count).by(1)
      expect(library.reload.users.first.name).to eq(user.name)
      expect(User.first.libraries.first.name).to eq(library.name)
    end

    it "finds an existing user and creates a new borrower releationship" do
      borrower = FactoryBot.create(:borrower)
      user = borrower.user
      new_library = FactoryBot.create(:library, name: 'New Library')

      expect {
        post library_borrowers_path(
          new_library.id,
          user: user.attributes
        )
      }.to change(Borrower, :count).by(1)
       .and change(User, :count).by(0)
    end
  end
end
