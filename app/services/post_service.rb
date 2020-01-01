class PostService
  require "google/cloud/storage"

  def self.get_all(params)
    id = params[:id] if params[:id].present?

    posts = Post.all
    posts = posts.where(id: id) if id.present?
    posts = posts.order("created_at desc")
    count = posts.count

    return {
      success: true,
      total: count,
      posts: posts.as_json(Post.as_json_query)
    }
  end

  def self.create_post(current_user, params)
    title = params[:title] if params[:title].present?
    raise "title is not provided" if title.blank?
    content = params[:content] if params[:content].present?
    raise "content is not provided" if content.blank?
    file = params[:file] if params[:file].present?
    raise "file is not provided" if file.blank?

    url = upload_image(file)
    
    create_params = {
      user_id: current_user.id,
      title: title,
      content: content,
      media: url
    }

    post = Post.create!(create_params)

    return {
      success: true,
      post: post.as_json(Post.as_json_query)
    }
  end

  def self.update_post(current_user, params)
    post_id = params[:id]
    raise "post id not present" if post_id.blank?
    post = Post.where(id: post_id).first
    raise "post not found" if post.blank?
    raise "You cannot update this post" if post.user_id != current_user.id

    title = params[:title] if params[:title].present?
    content = params[:content] if params[:content].present?
    file = params[:file] if params[:file].present?

    url = upload_image(file) if file.present?

    update_params = {}
    update_params.merge!(title: title) if title.present?
    update_params.merge!(content: content) if content.present?
    update_params.merge!(media: file.tempfile) if file.present?
    
    post.update_attributes!(update_params)
    return {
      success: true,
      post: post.as_json(Post.as_json_query)
    }
  end

   def self.upload_image(file)
    begin
      bucket_name = Figaro.env.BUCKET_NAME
      storage = Google::Cloud::Storage.new
      bucket = storage.bucket bucket_name
      file = bucket.create_file( file.tempfile, content_type: file.content_type, acl: "public")
      file.public_url
    rescue => err
      raise err
    end
  end

  def self.delete_post(current_user, params)
    post_id = params[:id]
    raise "post id not present" if post_id.blank? 
    post = Post.where(id: post_id).first
    raise "post with given id not present" if post.blank?
    raise "You cannot delete this post" if post.user_id != current_user.id
    post.destroy!
    return {
      success: true
    }
  end
end