class CommentService
  def self.create_comment(current_user, params)
    post_id = params[:post_id]
    raise "post id not present" if post_id.blank?
    title = params[:title]
    content = params[:content]
    raise "content id not present" if content.blank?
    create_params = {
      user_id: current_user.id,
      post_id: post_id,
      title: title,
      content: content
    }
    comment = Comment.create!(create_params)
    return {
      success: true,
      comment: comment.as_json
    }
  end

  def self.delete_comment(current_user, params)
    comment_id = params[:id]
    raise "comment id not present" if comment_id.blank?
    comment = Comment.where(id: comment_id).first
    raise "comment with given id not present" if comment.blank?
    raise "You cannot delete this comment" if comment.user_id != current_user.id
    comment.destroy!
    return {
      success: true
    }
  end
end