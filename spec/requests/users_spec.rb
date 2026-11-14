
require "rails_helper"

RSpec.describe "Users", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) do
    User.create!(
      username: "john",
      email: "john@example.com",
      password: "password123"
    )
  end

  before do
    sign_in user
  end

  describe "GET /users/:id" do
    it "displays a user's profile" do
      get user_path(user)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("john")
    end
  end
end
