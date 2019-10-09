module Usecase
  class JwtAuthentication
    module Exception
      class TokenNotPresentError < StandardError; end
      class TokenNotValidError < StandardError; end
    end

    def initialize(auth_gateway:)
      @auth_gateway = auth_gateway
    end

    def execute(token:)
      raise Exception::TokenNotPresentError if token.nil? || token.empty?

      begin
        hmac_secret = auth_gateway.hmac_secret
        JWT.decode(token, hmac_secret, true, algorithm: 'HS256')
      rescue JWT::DecodeError => e
        raise Exception::TokenNotValidError, e
      end

      true
    end

    private

    attr_reader :auth_gateway
  end
end
