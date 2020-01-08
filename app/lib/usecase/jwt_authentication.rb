module Usecase
  class JwtAuthentication
    module Exception
      class TokenNotPresentError < StandardError; end
      class TokenNotValidError < StandardError; end
    end

    def initialize(auth_gateway:, token:, algorithm:)
      @auth_gateway = auth_gateway
      @token = token
      @algorithm = algorithm
    end

    def execute
      raise Exception::TokenNotPresentError if token.nil? || token.empty?

      begin
        validate_token
      rescue JWT::DecodeError => e
        raise Exception::TokenNotValidError, e
      end
    end

    private

    def validate_token
      raise Exception::TokenNotValidError, 'iss header must be present' if issuer_claim.nil?

      JWT.decode(token, hmac_secret, true, algorithm: algorithm)
    end

    def hmac_secret
      auth_gateway.hmac_secret(issuer_claim: issuer_claim)
    end

    def issuer_claim
      @issuer_claim ||= JWT.decode(token, key = nil, verify = false).last['iss'] # rubocop:disable Lint/UselessAssignment
    end

    attr_reader :auth_gateway, :token, :algorithm
  end
end
