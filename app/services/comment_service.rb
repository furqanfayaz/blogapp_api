class CommentService
  def self.create(current_user, params)
    post_id = params[:post_id].present? ? params[:post_id] : raise " post id not present"
    title = params[:title].present? params[:title] : raise "title not present"
    content = params[:content].present? ? params[:content] : raise "content not present"
    create_params = {
      user_id = current_user.id,
      post_id = post_id,
      title = title,
      content = content
    }
    comment = Comment.create!(create_params)
    return {
      success: true,
      comment: comment.as_json
    }
  end

  def self.delete(current_user, params)
    comment_id = params[:id].present? ? params[:id] : raise "id not present"
    comment = Comment.where(id: comment_id).first
    raise "comment with given id not present" if comment.blank?
    raise "You cannot delete this comment" if comment.user_id != current_user.id
    comment.delete!
    return {
      success: true
    }
  end
end