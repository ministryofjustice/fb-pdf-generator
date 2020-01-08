require 'webmock/rspec'
require 'gateway/public_key'

RSpec.describe Gateway::PublicKey do
  subject(:gateway) { described_class.new }

  let(:service_slug) { 'service-slug' }
  let(:encoded_public_key) do
    'LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUEzU1RCMkxnaDAyWWt0K0xxejluNgo5MlNwV0xFdXNUR1hEMGlmWTBuRHpmbXF4MWVlbHoxeHhwSk9MZXRyTGdxbjM3aE1qTlkwL25BQ2NNZHVFSDlLClhycmFieFhYVGwxeVkyMStnbVd4NDlOZVlESW5iZG0rNnM1S3ZMZ1VOTjdYVmNlUDlQdXFaeXN4Q1ZBNFRubUwKRURLZ2xTV2JVeWZ0QmVhVENKVkk2NFoxMmRNdFBiQWd4V0FmZVNMbGI3QlBsc0htL0gwQUFMK25iYU9Da3d2cgpQSkRMVFZPek9XSE1vR2dzMnJ4akJIRC9OV05ac1RWUWFvNFh3aGVidWRobHZNaWtFVzMyV0tnS3VISFc4emR2ClU4TWozM1RYK1picVhPaWtkRE54dHd2a1hGN0xBM1loOExJNUd5ZDlwNmYyN01mbGRnVUlIU3hjSnB5MUo4QVAKcXdJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0tCg=='
  end
  let(:configuration) { instance_double('configuration', auth_endpoint: 'http://example.com') }

  before do
    allow(Rails).to receive(:configuration).and_return(configuration)
    WebMock.stub_request(:get, "#{Rails.configuration.auth_endpoint}/service/v2/#{service_slug}").to_return(status: 200, body: encoded_public_key)
  end

  it 'can get public key' do
    expect(gateway.hmac_secret(issuer_claim: service_slug).to_pem).to eq(Base64.strict_decode64(encoded_public_key))
  end

  context 'when there is a failing responce' do
    before do
      WebMock.stub_request(:get, "#{Rails.configuration.auth_endpoint}/service/v2/#{service_slug}").to_return(status: 500)
    end

    it 'thows an error' do
      expect do
        gateway.hmac_secret(issuer_claim: service_slug)
      end.to raise_error(StandardError)
    end
  end
end
