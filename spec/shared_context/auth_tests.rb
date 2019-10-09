require 'webmock/rspec'

RSpec.shared_context 'when authentication required', when_authentication_required: :metadata do
  let(:url) { raise "set the url to test auth vs ie. 'let(:url) { '/v1/complaint'}' " }

  before do
    stub_request(:get, expected_url).to_return(
      status: 200,
      body: { token: token_secret }.to_json
    )
  end

  let(:expected_url)  { "#{Rails.configuration.auth_endpoint}service/#{issuer_claim}" }

  let(:token_secret) { SecureRandom.alphanumeric(10) }
  let(:issuer_claim) { SecureRandom.alphanumeric(5)  }

  let(:token) do
    JWT.encode({ data: 'hello!' }, token_secret, 'HS256', iss: issuer_claim)
  end

  let(:auth_headers) { { 'x-access-token' => token } }

  it 'requires authentication' do
    post url
    expect(response).to have_http_status(:unauthorized)
  end

  it 'stub auth request is called' do
    post url
    expect(WebMock).to have_requested(:get, expected_url).once
  end
end
