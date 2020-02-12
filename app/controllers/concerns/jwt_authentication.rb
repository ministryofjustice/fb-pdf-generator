module JwtAuthentication
  extend ActiveSupport::Concern
  JWT_ALGORITHM = 'RS256'.freeze

  included do
    before_action :authorize_request
  end

  def authorize_request
    Usecase::JwtAuthentication.new(
      auth_gateway: Gateway::PublicKey.new,
      token: request.headers['x-access-token-v2'],
      algorithm: JWT_ALGORITHM
    ).execute
  rescue Usecase::JwtAuthentication::Exception::TokenNotPresentError
    head :unauthorized
  rescue Usecase::JwtAuthentication::Exception::TokenNotValidError
    head :forbidden
  end
end
