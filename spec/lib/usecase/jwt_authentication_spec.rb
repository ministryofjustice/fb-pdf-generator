require 'jwt'
require 'usecase/jwt_authentication'
require 'gateway/authentication'

RSpec.describe Usecase::JwtAuthentication do
  let(:auth_gateway) { instance_spy(Gateway::Authentication) }

  context 'when given no token' do
    it 'nil returns an exception' do
      expect do
        described_class.new(auth_gateway: auth_gateway, token: nil).execute
      end.to raise_error(Usecase::JwtAuthentication::Exception::TokenNotPresentError)
    end

    it 'empty string returns an exception' do
      expect do
        described_class.new(auth_gateway: auth_gateway, token: '').execute
      end.to raise_error(Usecase::JwtAuthentication::Exception::TokenNotPresentError)
    end
  end

  context 'when given invalid token' do
    it 'returns an exception' do
      expect do
        described_class.new(auth_gateway: auth_gateway, token: 'foo').execute
      end.to raise_error(Usecase::JwtAuthentication::Exception::TokenNotValidError)
    end
  end

  context 'with a valid token' do
    before do
      allow(auth_gateway).to receive(:hmac_secret).and_return(hmac_secret)
    end

    let(:hmac_secret) { SecureRandom.alphanumeric(24) }

    let(:jwt_token_payload) { { data: 'data', iat: Time.now.to_i } }
    let(:jwt_token_headers) { { iss: 'some_service' } }

    let(:jwt_token) do
      JWT.encode jwt_token_payload, hmac_secret, 'HS256', jwt_token_headers
    end

    context 'without a iat header' do
      let(:jwt_token_headers) { {} }

      it 'returns an exception' do
        expect do
          described_class.new(auth_gateway: auth_gateway, token: jwt_token).execute
        end.to raise_error(Usecase::JwtAuthentication::Exception::TokenNotValidError).with_message('iss header must be present')
      end
    end

    it 'returns if there is no problem' do
      expect { described_class.new(auth_gateway: auth_gateway, token: jwt_token).execute }.not_to raise_error
    end

    it 'gets the hmac_secret from the auth gateway' do
      described_class.new(auth_gateway: auth_gateway, token: jwt_token).execute

      expect(auth_gateway).to have_received(:hmac_secret).once
    end

    it 'passes the Issuer Claim header to the gateway' do
      described_class.new(auth_gateway: auth_gateway, token: jwt_token).execute

      expect(auth_gateway).to have_received(:hmac_secret).with(issuer_claim: 'some_service').once
    end
  end
end
