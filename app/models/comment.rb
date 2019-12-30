class Comment < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  belongs_to :post, foreign_key: "post_id"

  validates :title, presence: true
  validates :content, presence: true
end