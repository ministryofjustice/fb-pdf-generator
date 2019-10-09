require 'rails_helper'

RSpec.describe PdfGeneratorController, type: :request do
  include_context 'when authentication required' do
    let(:url) { '/v1/pdf' }

    it 'can be requested' do
      post url, headers: auth_headers
      expect(response).to have_http_status(:ok)
    end

    it 'can be called' do
      post url, headers: auth_headers
      expect(response.body).to eq({ placeholder: true }.to_json)
    end
  end
end
