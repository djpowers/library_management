require 'rails_helper'

RSpec.describe "Borrowers", type: :request do
  describe "POST /" do
    it "creates a new user and borrower relationship" do
      library = FactoryBot.create(:library)
      user = FactoryBot.create(:user)

      expect {
        post borrowers_path(
          library_id: library.id,
          user_id: user.id
        )
      }.to change(Borrower, :count).by(1)
      expect(library.reload.users).to include(user)
      expect(user.reload.libraries).to include(library)
    end
  end
end
