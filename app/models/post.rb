class Post < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: "Post", optional: true
  has_many :replies, class_name: "Post", foreign_key: :parent_id

  has_many :likes
  has_many :liking_users, through: :likes, source: :user

  validates :content, presence: true
end
