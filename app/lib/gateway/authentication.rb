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

    def initialize(token_api_base_url:, service_slug:)
      self.class.base_uri token_api_base_url

      @service_slug = service_slug
    end

    def hmac_secret
      response = self.class.get("/service/#{service_slug}")
      raise AuthenticationApiError, response unless response.success?

      response.fetch('token')
    end

    private

    attr_reader :service_slug
  end
end
