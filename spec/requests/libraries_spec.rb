require 'rails_helper'

RSpec.describe "Libraries", type: :request do
  describe "POST /libraries" do
    it "creates a new libraries record" do
      expect {
        post libraries_path(name: 'Little Free Library')
      }.to change(Library, :count).by(1)
    end
  end
end
