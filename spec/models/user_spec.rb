require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it "has many posts" do
      association = User.reflect_on_association(:posts)

      expect(association.macro).to eq(:has_many)
    end

    it "has many likes" do
      association = User.reflect_on_association(:likes)

      expect(association.macro).to eq(:has_many)
    end
  end

  describe "association behavior" do
  it "returns posts belonging to a user" do
    john = User.create!(
      username: "john",
      email: "john@example.com",
      password: "password123"
    )

    post = john.posts.create!(content: "Hello Odinbook!")

    expect(john.posts).to include(post)
  end

  it "returns posts liked by a user" do
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

    mary.likes.create!(post: post)

    expect(mary.liked_posts).to include(post)
  end

  it "returns users followed by another user" do
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

    mary.active_follows.create!(followed: john)

    expect(mary.following).to include(john)
    expect(john.followers).to include(mary)
  end
end
end
