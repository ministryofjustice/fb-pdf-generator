class ApplicationController < ActionController::API
  before_action :authorize_request

  def authorize_request
    Usecase::JwtAuthentication.new(
      auth_gateway: Gateway::Authentication.new(token_api_base_url: Rails.configuration.auth_endpoint),
      token: request.headers['x-access-token']
    ).execute
  rescue Usecase::JwtAuthentication::Exception::TokenNotPresentError
    render status: :unauthorized
  rescue Usecase::JwtAuthentication::Exception::TokenNotValidError
    render status: :forbidden
  end
end
