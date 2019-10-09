require 'rails_helper'
require 'jwt'

RSpec.describe Usecase::JwtAuthentication do
  subject(:usecase) { described_class.new(auth_gateway: auth_gateway) }

  let(:auth_gateway) { instance_spy(Gateway::Authentication) }

  context 'when given no token' do
    it 'nil returns an exception' do
      expect do
        usecase.execute(token: nil)
      end.to raise_error(Usecase::JwtAuthentication::Exception::TokenNotPresentError)
    end

    it 'empty string returns an exception' do
      expect do
        usecase.execute(token: '')
      end.to raise_error(Usecase::JwtAuthentication::Exception::TokenNotPresentError)
    end
  end

  context 'when given invalid token' do
    it 'returns an exception' do
      expect do
        usecase.execute(token: 'foo')
      end.to raise_error(Usecase::JwtAuthentication::Exception::TokenNotValidError)
    end
  end

  context 'with a valid token' do
    before do
      allow(auth_gateway).to receive(:hmac_secret).and_return(hmac_secret)
    end

    let(:hmac_secret) { SecureRandom.alphanumeric(24) }

    let(:jwt_token_payload) { { data: 'data', iat: Time.now.to_i } }

    let(:jwt_token) do
      JWT.encode jwt_token_payload, hmac_secret, 'HS256'
    end

    it 'returns true' do
      expect(usecase.execute(token: jwt_token)).to be true
    end

    it 'gets the hmac_secret from the auth gateway' do
      usecase.execute(token: jwt_token)

      expect(auth_gateway).to have_received(:hmac_secret).once
    end
  end
end
