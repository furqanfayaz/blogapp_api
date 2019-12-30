class PostService
  def self.get_all(params)
    posts = Post.all
    posts = posts.order("created_at desc")
    count = posts.count
    return {
      success: true,
      total: count,
      posts: posts.as_json(Post.as_json_query)
    }
  end

  def self.create_post(current_user, params)
    title = params[:title].present? ? params[:title] : raise "title not present"
    content = params[:content].present? ? params[:content] : raise "content not present"
    media = params[:media].present? ? params[:media] : raise "media not present"

    create_params = {
      user_id: current_user.id,
      title: title,
      content: content,
      media: media.tempfile
    }

    post = Post.create!(create_params)

    return {
      success: true,
      post: post.as_json(Post.as_json_query)
    }
  end

  def self.update_post(current_user, params)
    post_id = params[:id].present? ? params[:id] : raise "post id not present"
    post = Post.where(id: post_id).first
    raise "You cannot update this post" if post.user_id != current_user.id

    title = params[:title] if params[:title].present?
    content = params[:content] if params[:content].present?
    media = params[:media] if params[:media].present?
    update_params = {
      title: title,
      content: content,
      media: media.tempfile
    }

    post.update!(update_params)
    return {
      success: true,
      post: post.as_json(Post.as_json_query)
    }
  end

  def self.delete_post(current_user, params)
    post_id = params[:id].present? ? params[:id] : raise "post id not present"
    post = Post.where(id: post_id).first
    raise "post with given id not present" if post.blank?
    raise "You cannot delete this post" if post.user_id != current_user.id
    post.delete!
    return {
      success: true
    }
  end
end