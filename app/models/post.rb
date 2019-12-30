class Post < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  has_many :comments, inverse_of: :post, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
  validates :media, presence: true

  def self.as_json_query
    return {
        only: [:title, :content, :media],
        methods: [:comments, :user_details]
    }
  end

  def comments
    return self.comments.as_json
  end

  def user_details
    return User.where(id: self.user_id).as_json
  end
end