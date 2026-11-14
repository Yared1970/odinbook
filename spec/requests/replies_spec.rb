
require "rails_helper"

RSpec.describe "Replies", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) do
    User.create!(
      username: "john",
      email: "john@example.com",
      password: "password123"
    )
  end

  let(:parent_post) do
    user.posts.create!(content: "Original post")
  end

  before do
    sign_in user
  end

  describe "POST /posts/:post_id/replies" do
    it "creates a reply belonging to the original post" do
      parent_post

      expect {
        post post_replies_path(parent_post),
             params: {
               post: { content: "My reply" }
             }
      }.to change(Post, :count).by(1)

      reply = Post.last

      expect(reply.parent).to eq(parent_post)
      expect(reply.user).to eq(user)
      expect(response).to redirect_to(post_path(parent_post))
    end

    it "rejects an empty reply" do
      parent_post

      expect {
        post post_replies_path(parent_post),
             params: {
               post: { content: "" }
             }
      }.not_to change(Post, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
