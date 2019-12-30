class Api::V1::PostsController < RegisteredController
  before_action :set_service

  def create
    response  = @service.create_post(@current_user, create_params)
    render json: response
  end

  def update
    response  = @service.update_post(@current_user, update_params)
    render json: response
  end

  def index
    response  = @service.get_all(params)
    render json: response
  end

  def delete
    response  = @service.delete_post(@current_user, params)
    render json: response
  end

  private

  def set_service
    @service ||= ::PostService
  end

  def create_params
    params.permit(:title, :content, :media)
  end

  def update_params
    params.permit(:id, :title, :content, :media)
  end
end