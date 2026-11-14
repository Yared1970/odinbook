
require "rails_helper"

RSpec.describe "Posts", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) do
    User.create!(
      username: "john",
      email: "john@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  before do
    sign_in user
  end

  describe "GET /posts" do
    it "returns a successful response" do
      get posts_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /posts/:id" do
    it "returns a successful response" do
      post = user.posts.create!(
        content: "Hello Odinbook!"
      )

      get post_path(post)

      expect(response).to have_http_status(:ok)
    end
  end


describe "GET /posts/new" do
  it "displays the new post form" do
    get new_post_path

    expect(response).to have_http_status(:ok)
  end
end

describe "POST /posts" do
  it "creates a post for the signed-in user" do
    expect {
      post posts_path, params: {
        post: { content: "Hello Odinbook!" }
      }
    }.to change(Post, :count).by(1)

    expect(Post.last.user).to eq(user)
    expect(response).to redirect_to(post_path(Post.last))
  end

  it "does not save a post without content" do
    expect {
      post posts_path, params: {
        post: { content: "" }
      }
    }.not_to change(Post, :count)

    expect(response).to have_http_status(:unprocessable_content)
  end
end


describe "Personalized feed" do
  it "shows posts from followed users" do
    john = User.create!(
      username: "followed_john",
      email: "followed_john@example.com",
      password: "password123"
    )

    john.posts.create!(
      content: "John's followed post"
    )

    user.active_follows.create!(followed: john)

    get posts_path

    expect(response.parsed_body.text).to include("John's followed post")
  end

  it "does not show posts from users not followed" do
    david = User.create!(
      username: "unfollowed_david",
      email: "unfollowed_david@example.com",
      password: "password123"
    )

    david.posts.create!(
      content: "David's unrelated post"
    )

    get posts_path

    expect(response.body).not_to include("David's unrelated post")
  end

  it "shows the signed-in user's own posts" do
    user.posts.create!(
      content: "My own Odinbook post"
    )

    get posts_path

    expect(response.body).to include("My own Odinbook post")
  end

  it "does not show replies in the main feed" do
    parent = user.posts.create!(
      content: "Original post"
    )

    user.posts.create!(
      content: "Reply to original",
      parent: parent
    )

    get posts_path

    expect(response.body).to include("Original post")
    expect(response.body).not_to include("Reply to original")
  end
end
end
