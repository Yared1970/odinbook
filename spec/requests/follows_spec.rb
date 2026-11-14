
require "rails_helper"

RSpec.describe "Follows", type: :request do
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

  before do
    sign_in mary
  end

  describe "POST /users/:user_id/follow" do
    it "allows Mary to follow John" do
      expect {
        post user_follow_path(john)
      }.to change(Follow, :count).by(1)

      expect(mary.following).to include(john)
      expect(john.followers).to include(mary)
      expect(response).to redirect_to(user_path(john))
    end

    it "prevents duplicate follows" do
      mary.active_follows.create!(followed: john)

      expect {
        post user_follow_path(john)
      }.not_to change(Follow, :count)
    end

    it "prevents Mary from following herself" do
      expect {
        post user_follow_path(mary)
      }.not_to change(Follow, :count)
    end
  end

  describe "DELETE /users/:user_id/follow" do
    it "allows Mary to unfollow John" do
      mary.active_follows.create!(followed: john)

      expect {
        delete user_follow_path(john)
      }.to change(Follow, :count).by(-1)

      expect(mary.following).not_to include(john)
      expect(response).to redirect_to(user_path(john))
    end
  end
end
