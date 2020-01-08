module JwtAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authorize_request
  end

  def authorize_request
    Usecase::JwtAuthentication.new(
      auth_gateway: jwt_gateway,
      token: jwt_token,
      algorithm: jwt_algorithm
    ).execute
  rescue Usecase::JwtAuthentication::Exception::TokenNotPresentError
    head :unauthorized
  rescue Usecase::JwtAuthentication::Exception::TokenNotValidError
    head :forbidden
  end

  private

  def jwt_gateway
    if request.headers['x-access-token-v2']
      Gateway::PublicKey.new
    else
      Gateway::Authentication.new(token_api_base_url: Rails.configuration.auth_endpoint)
    end
  end

  def jwt_token
    request.headers['x-access-token-v2'] || request.headers['x-access-token']
  end

  def jwt_algorithm
    if request.headers['x-access-token-v2']
      'RS256'
    else
      'HS256'
    end
  end
end
