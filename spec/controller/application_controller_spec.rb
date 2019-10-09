require 'rails_helper'
require 'webmock/rspec'

RSpec.describe ApplicationController, type: :controller do
  describe '#authorize_request requires jwt token' do
    # test controller to test ApplicationController logic
    controller(described_class) do
      def create
        render json: { allgood: true }, status: :ok
      end
    end

    before do
      stub_request(:get, "#{Rails.configuration.auth_endpoint}service/some_other_api").to_return(
        status: 200,
        body: { token: token_secret }.to_json
      )
    end

    let(:token_secret) { 'my$ecretK3y' }
    let(:issuer_claim) { 'some_other_api' }

    let(:token) do
      JWT.encode({ data: 'hello!' }, token_secret, 'HS256', iss: issuer_claim)
    end

    it 'rejects unauthorized when no token' do
      post :create
      expect(response).to have_http_status(:unauthorized)
    end

    it 'rejects forbidden when invalid token' do
      request.headers['x-access-token'] = 'nonsence'
      post :create
      expect(response).to have_http_status(:forbidden)
    end

    it 'ok with token' do
      request.headers['x-access-token'] = token
      post :create
      expect(response).to have_http_status(:ok)
    end

    it 'runs controller method with token' do
      request.headers['x-access-token'] = token
      post :create
      expect(response.body).to eq({ allgood: true }.to_json)
    end
  end
end
