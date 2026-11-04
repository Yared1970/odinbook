require "rails_helper"

RSpec.describe Follow, type: :model do
  describe "associations" do
    it "belongs to a follower" do
      association = Follow.reflect_on_association(:follower)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("User")
    end

    it "belongs to a followed user" do
      association = Follow.reflect_on_association(:followed)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("User")
    end
  end

  describe "follow behavior" do
  it "connects a follower to a followed user" do
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

    follow = mary.active_follows.create!(followed: john)

    expect(follow.follower).to eq(mary)
    expect(follow.followed).to eq(john)
  end

  it "prevents a user from following themselves" do
    john = User.create!(
      username: "john",
      email: "john@example.com",
      password: "password123"
    )

    follow = Follow.new(follower: john, followed: john)

    expect(follow).not_to be_valid
  end

  it "prevents duplicate following relationships" do
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

    duplicate_follow = mary.active_follows.build(followed: john)

    expect(duplicate_follow).not_to be_valid
  end
end
end
