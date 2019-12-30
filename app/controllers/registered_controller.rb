class RegisteredController < ApplicationController
   before_action :check_user
  def current_user
    @current_user ||= SessionService.fetch({token: params[:cookie]})
  end

  def check_user
    if current_user.nil?
      render json: {success: false, is_authenticated: false}, status: 401
    end
  end
end