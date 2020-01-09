require 'httparty'

module Gateway
  class PublicKey
    include HTTParty

    def initialize
      self.class.base_uri(base_url)
    end

    def hmac_secret(issuer_claim:)
      response = self.class.get("/service/v2/#{issuer_claim}")
      raise StandardError, response unless response.success?

      OpenSSL::PKey::RSA.new(Base64.strict_decode64(response.body))
    end

    private

    def base_url
      Rails.configuration.auth_endpoint
    end
  end
end
