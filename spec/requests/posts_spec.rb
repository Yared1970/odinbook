require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "returns a successful response" do
      get posts_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /posts/:id" do
    it "returns a successful response" do
      user = User.create!(
        username: "john",
        email: "john@example.com",
        password: "password123"
      )

      post = user.posts.create!(
        content: "Hello Odinbook!"
      )

      get post_path(post)

      expect(response).to have_http_status(:ok)
    end
  end
end
