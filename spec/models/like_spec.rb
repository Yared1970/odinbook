require "rails_helper"

RSpec.describe Like, type: :model do
  describe "associations" do
    it "belongs to a user" do
      association = Like.reflect_on_association(:user)

      expect(association.macro).to eq(:belongs_to)
    end

    it "belongs to a post" do
      association = Like.reflect_on_association(:post)

      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "like behavior" do
  it "connects a user to a post" do
    john = User.create!(
      username: "john",
      email: "john@example.com",
      password: "password123"
    )

    mary = User.create!(
      username: "mary",
      email: "mary@example.com",
      password: "password123"
    )

    post = john.posts.create!(content: "Hello!")

    like = mary.likes.create!(post: post)

    expect(like.user).to eq(mary)
    expect(like.post).to eq(post)
    expect(post.liking_users).to include(mary)
  end

  it "prevents a user from liking the same post twice" do
    john = User.create!(
      username: "john",
      email: "john@example.com",
      password: "password123"
    )

    post = john.posts.create!(content: "Hello!")

    john.likes.create!(post: post)

    duplicate_like = john.likes.build(post: post)

    expect(duplicate_like).not_to be_valid
  end
end
end
