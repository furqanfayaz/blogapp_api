class Api::V1::CommentsController < RegisteredController
  before_action :set_service

  def create
    response  = @service.create_comment(@current_user, create_params)
    render json: response
  end

  def delete
    response  = @service.delete_comment(@current_user, params)
    render json: response
  end

  private

  def set_service
    @service ||= ::CommentService
  end

  def create_params
    params.permit(:post_id, :title, :content)
  end

end