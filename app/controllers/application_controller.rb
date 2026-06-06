class ApplicationController < ActionController::API
  def authenticate_barbeiro!
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      payload = JWT.decode(token, Rails.application.secret_key_base)[0]
      @barbeiro_id = payload['barbeiro_id']
    else
      render json: { error: "Não autorizado" }, status: :unauthorized
    end
  rescue JWT::DecodeError
    render json: { error: "Token inválido" }, status: :unauthorized
  end
end
