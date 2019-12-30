class SessionService
  def self.user_session_token_key_name(token)
    "user_session_token_#{token}"
  end

  def self.user_session_id_key_name(user_id)
    "user_session_id_#{user_id}"
  end

  def self.signup(signup_params)
    email = signup_params[:email]
    user = User.where(email: email)
    raise "User already exists" if user.present?
    
    create_params = {
      name: signup_params[:name],
      email: signup_params[:email],
      password: signup_params[:password]
    }
    user = User.create!(create_params)
    
    return {
      success: true,
      user: user.as_json
    }
  end

  def self.create(session_params)
    email = session_params[:email].to_s.downcase
    password = session_params[:password]

    user = User.where(email: email).first
    raise "user with given email is not found" if user.blank?
    
    raise "Wrong email/password combination" if !user.authenticate(password)
  
    token = Digest::SHA1.hexdigest([Time.now, rand].join)

    # expire after 10 minutes
    $redis.multi do
      $redis.set(user_session_token_key_name(token), user.id)
      $redis.expire(user_session_token_key_name(token), 60*60)
      $redis.lpush(user_session_id_key_name(user.id), user_session_token_key_name(token))
      $redis.expire(user_session_id_key_name(user.id), 60*60)
    end

    return {
      success: true,
      token: token,
      user_details: user.as_json
    }
  end

  def self.delete_session(params)
    token = params[:cookie]
    user = fetch({token: token})
    $redis.multi do
      $redis.del(user_session_token_key_name(token))
      $redis.lrem(user_session_id_key_name(user.id), 0, user_session_token_key_name(token))
    end
    return {
      success: true
    }
  end


  def self.fetch(session_params)
    token = session_params[:token]
    return nil if token.blank?

    user_id = $redis.get(user_session_token_key_name(token))
    return nil if user_id.blank?
    
    user = User.find(user_id)
    raise 'User not found' if user.blank?

    return user
  end
end