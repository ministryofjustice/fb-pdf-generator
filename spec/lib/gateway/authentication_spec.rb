require 'webmock/rspec'

RSpec.describe Gateway::Authentication do
  subject(:gateway) do
    described_class.new(
      token_api_base_url: token_api_base_url,
      service_slug: 'other_api'
    )
  end

  before do
    WebMock.stub_request(:get, "#{token_api_base_url}/service/other_api").to_return(status: 200, body: { token: hmac_secret }.to_json)
  end

  let(:token_api_base_url) { 'example.com/foo/bar' }
  let(:hmac_secret) { SecureRandom.alphanumeric(24) }

  it 'can get a hmac secret' do
    expect(gateway.hmac_secret).to eq(hmac_secret)
  end

  it 'makes a request to the service token api' do
    gateway.hmac_secret
    expect(WebMock).to have_requested(:get, "#{token_api_base_url}/service/other_api").once
  end

  context 'when there is a failing responce' do
    before do
      WebMock.stub_request(:get, "#{token_api_base_url}/service/other_api").to_return(status: 500)
    end

    it 'thows an error' do
      expect do
        gateway.hmac_secret
      end.to raise_error(Gateway::Authentication::AuthenticationApiError)
        .with_message(%r{\[Authentication Api Error: Received 500 response from http://example.com/foo/bar/service/other_api\]})
    end
  end
end
