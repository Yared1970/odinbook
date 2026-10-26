class User < ApplicationRecord
  has_secure_password

  has_many :posts
  has_many :comments


  has_many :likes
  has_many :liked_posts, through: :likes, source: :post

  has_many :active_follows,
           class_name: "Follow",
           foreign_key: :follower_id

  has_many :following,
           through: :active_follows,
           source: :followed

  has_many :passive_follows,
           class_name: "Follow",
           foreign_key: :followed_id

  has_many :followers,
           through: :passive_follows,
           source: :follower

           validates :username, presence: true, uniqueness: true
           validates :email, presence: true, uniqueness: true
           validates :password, presence: true, length: { minimum: 6 }, if: :password_digest_changed?
end
