class Post < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  has_many :comments, inverse_of: :post, dependent: :destroy

  def self.as_json_query
    return {
        only: [:id, :title, :content, :media],
        methods: [:comments, :user_details]
    }
  end

  def comments
    return Comment.where(post_id: self.id).as_json
  end

  def user_details
    return self.user.as_json
  end
end