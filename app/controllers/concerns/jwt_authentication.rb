module JwtAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authorize_request, unless: :disable_jwt?
  end

  def authorize_request
    Usecase::JwtAuthentication.new(
      auth_gateway: Gateway::Authentication.new(token_api_base_url: Rails.configuration.auth_endpoint),
      token: request.headers['x-access-token']
    ).execute
  rescue Usecase::JwtAuthentication::Exception::TokenNotPresentError
    head :unauthorized
  rescue Usecase::JwtAuthentication::Exception::TokenNotValidError
    head :forbidden
  end

  private

  def disable_jwt?
    Rails.env.development?
  end
end
