require "rails_helper"

RSpec.describe "User authentication", type: :request do
  include Devise::Test::IntegrationHelpers
  let(:user) do
    User.create!(
      username: "john",
      email: "john@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  describe "User registration" do
    it "allows a visitor to register" do
      expect {
        post user_registration_path, params: {
          user: {
            username: "mary",
            email: "mary@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:redirect)
    end
  end

  describe "User login" do
    it "allows a registered user to sign in" do
      user

      post user_session_path, params: {
        user: {
          email: "john@example.com",
          password: "password123"
        }
      }

      expect(response).to have_http_status(:redirect)
      get posts_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "User logout" do
  it "allows a signed-in user to sign out" do
    sign_in user

    delete destroy_user_session_path

    expect(response).to have_http_status(:redirect)

    get posts_path

    expect(response).to redirect_to(new_user_session_path)
  end
end

  describe "Protected pages" do
    it "redirects visitors who are not signed in" do
      get posts_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
