require 'httparty'
module Gateway
  class Authentication
    class AuthenticationApiError < StandardError
      attr_reader :response
      def initialize(response)
        super
        @response = response
      end

      def to_s
        uri = response&.request&.last_uri.to_s
        "[Authentication Api Error: Received #{response&.code} response from #{uri}] #{super}"
      end
    end

    include HTTParty
    format :json

    def initialize(token_api_base_url:)
      self.class.base_uri token_api_base_url
    end

    def hmac_secret(issuer_claim:)
      response = self.class.get("/service/#{issuer_claim}")
      raise AuthenticationApiError, response unless response.success?

      response.fetch('token')
    end

    private

    attr_reader :service_slug
  end
end
