class Api::SessionsController < ApplicationController
  before_action :set_service

  def create_session
    response = @service.create(session_params)
    render json: response
  end

  def delete_session
    response = @service.delete_session(delete_params)
    render json: response
  end

  def fetch_session_details
    response = @service.fetch(session_params)
    render json: response
  end

  def signup
    response = @service.signup(signup_params)
    render json: response
  end

  private

  def set_service
    @service ||= ::SessionService
  end

  def session_params
    response = params.permit(:email, :password, :token)
    response
  end

  def signup_params
    response = params.permit(:email, :password, :name)
    response
  end

  def delete_params
    params.permit(:cookie)
  end
end