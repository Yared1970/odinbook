
require "rails_helper"

RSpec.describe "Likes", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:john) do
    User.create!(
      username: "john",
      email: "john@example.com",
      password: "password123"
    )
  end

  let(:mary) do
    User.create!(
      username: "mary",
      email: "mary@example.com",
      password: "password123"
    )
  end

  let(:post_record) do
    john.posts.create!(content: "Hello Odinbook!")
  end

  before do
    sign_in mary
  end

  describe "POST /posts/:post_id/like" do
    it "allows a user to like a post" do
      post_record

      expect {
        post post_like_path(post_record)
      }.to change(Like, :count).by(1)

      expect(post_record.liking_users).to include(mary)
      expect(response).to redirect_to(post_path(post_record))
    end

    it "does not create duplicate likes" do
      mary.likes.create!(post: post_record)

      expect {
        post post_like_path(post_record)
      }.not_to change(Like, :count)
    end
  end

  describe "DELETE /posts/:post_id/like" do
    it "allows a user to unlike a post" do
      mary.likes.create!(post: post_record)

      expect {
        delete post_like_path(post_record)
      }.to change(Like, :count).by(-1)

      expect(response).to redirect_to(post_path(post_record))
    end
  end
end
