require "rails_helper"

RSpec.describe Post, type: :model do
  describe "associations" do
    it "belongs to a user" do
      association = Post.reflect_on_association(:user)

      expect(association.macro).to eq(:belongs_to)
    end

    it "has many replies" do
      association = Post.reflect_on_association(:replies)

      expect(association.macro).to eq(:has_many)
    end

    it "has many likes" do
      association = Post.reflect_on_association(:likes)

      expect(association.macro).to eq(:has_many)
    end
  end

  describe "association behavior" do
  it "returns the author of a post" do
    john = User.create!(
      username: "john",
      email: "john@example.com",
      password: "password123"
    )

    post = john.posts.create!(content: "My first post")

    expect(post.user).to eq(john)
  end

  it "returns replies to a post" do
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

    post = john.posts.create!(content: "Hello everyone!")

    reply = mary.posts.create!(
      content: "Hello John!",
      parent: post
    )

    expect(post.replies).to include(reply)
    expect(reply.parent).to eq(post)
  end
end
end
