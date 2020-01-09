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
      JWT.encode({ data: 'hello!', iss: issuer_claim }, token_secret, 'HS256')
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

    context 'when x-access-token-v2 provided' do
      let(:encoded_public_key) do
        'LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUEzU1RCMkxnaDAyWWt0K0xxejluNgo5MlNwV0xFdXNUR1hEMGlmWTBuRHpmbXF4MWVlbHoxeHhwSk9MZXRyTGdxbjM3aE1qTlkwL25BQ2NNZHVFSDlLClhycmFieFhYVGwxeVkyMStnbVd4NDlOZVlESW5iZG0rNnM1S3ZMZ1VOTjdYVmNlUDlQdXFaeXN4Q1ZBNFRubUwKRURLZ2xTV2JVeWZ0QmVhVENKVkk2NFoxMmRNdFBiQWd4V0FmZVNMbGI3QlBsc0htL0gwQUFMK25iYU9Da3d2cgpQSkRMVFZPek9XSE1vR2dzMnJ4akJIRC9OV05ac1RWUWFvNFh3aGVidWRobHZNaWtFVzMyV0tnS3VISFc4emR2ClU4TWozM1RYK1picVhPaWtkRE54dHd2a1hGN0xBM1loOExJNUd5ZDlwNmYyN01mbGRnVUlIU3hjSnB5MUo4QVAKcXdJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0tCg=='
      end

      let(:encoded_private_key) { 'LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBM1NUQjJMZ2gwMllrdCtMcXo5bjY5MlNwV0xFdXNUR1hEMGlmWTBuRHpmbXF4MWVlCmx6MXh4cEpPTGV0ckxncW4zN2hNak5ZMC9uQUNjTWR1RUg5S1hycmFieFhYVGwxeVkyMStnbVd4NDlOZVlESW4KYmRtKzZzNUt2TGdVTk43WFZjZVA5UHVxWnlzeENWQTRUbm1MRURLZ2xTV2JVeWZ0QmVhVENKVkk2NFoxMmRNdApQYkFneFdBZmVTTGxiN0JQbHNIbS9IMEFBTCtuYmFPQ2t3dnJQSkRMVFZPek9XSE1vR2dzMnJ4akJIRC9OV05aCnNUVlFhbzRYd2hlYnVkaGx2TWlrRVczMldLZ0t1SEhXOHpkdlU4TWozM1RYK1picVhPaWtkRE54dHd2a1hGN0wKQTNZaDhMSTVHeWQ5cDZmMjdNZmxkZ1VJSFN4Y0pweTFKOEFQcXdJREFRQUJBb0lCQUU5ZjJTQVRmemlraWZ0aQp2RXRjZnlMN0EzbXRKd2c4dDI2cDcyT3czMUg0RWg4NHlOaWFHbE5ld2lialAvWW5wdmU2NitjRkg4SlBxK0NWCkJHRnhmdDBmampXZkRrZTNiTTVaUjdaQUVDaW8vay9pMEpveU5MK015ZkNRMWRmZ1FFUXV1L0gvdnJzSEdyT3cKRW5YQVZIUzg1enlCWWczbjM4QmxjVkw4V2s4R3FlMGxCUU5RSks5dSt5ckc5NEpoUTVoMTZubXlyQ0xpWkhSTAoyWS94MTdDL3BCN1VlUVFWeDZ4aVZSdVdmT1FoWlNmT2IzRHpsYldhc2owa2pTaHdWWDFQVG5sU0lxQXo5T3krClY5M013VFBtbVNOOGFiL0pGVlVBUzhtckM2elcxc0NjcFVUTFZHRVZBUFBJcWpjMmZFKzdLVGNjVDFzWkt0MWIKb2p1R2xSa0NnWUVBL2ZuK3VZcCtxSzdiQmxkUTZCSmNsNXpkR0xybXRrWFFZR096d2cvN21zd0NVdUM3UFpGYQpJV0xBSGM4QU85eDZvUFQ0SzFPNnQzYVBtMW8vUTR1S1N2NWNGK3EwaThMemVQM2JxdnowQXBXekdPVFdiMXg5CnNBRzNIOCtIT3JNS0NXVWl3bm5pUG1PMDNXUUY0dmFoWUd1WXYzSkNSNTYxanBJOFRkMkx6QmNDZ1lFQTN1ZkwKKzdqNGE2elVBOUNrak5wSnB2VkxyQk8ydUpiRHk5NXBpSzlCU3FIellQSEw3VVBWTExFaXRGWlNBWlRWRzFHMwpWbUNxMVoraXhCcTRST0t2VldyME1mSklsUlEvQXBQY3NwVXJjRTRPcnAxRkEyNjlLdXhhdnI5dmpLMCtIbWNRClEydWNRWWdUeWFXQlNZeW9laW04QWQ2UlpJRzVLQ25uTVlhNThZMENnWUVBNUp6VG5VLzlFdm5TVGJMck1QclcKUGVNRlllMWJIMWRZYW10VXM2cVBZSmVpdjlkcXM5RFN3SnFUTkVIUWhCSENrSC94bzQ2SzAvbjA2bkloNERzTApFTlpGTDRJbFltanBvRTlpSEZmMWpSNFRTS1UwSUttd3VXM1IyT0NGYVdFZjk3VUJ4T3pScWpjMTV0TFNPYXFuCk9KT2h1ekt1VnFtVjQrL2VPSGprRGFFQ2dZQUdMVFloeTRaV3RYdEtmOFdQZ1p6NDIyTTFhWFp1dHY3Rjcydk4KTmM0QlcydDdERGd5WXViTlRqcy85QVJodHRZUTQ3ckkwZlRwNW5xRUpKbG1qMEY4aEhJdjBCN2l3cVRjVld5UQpKa0lGNHFQVmd0WWV1anJUcmFqMkVDZnZKZjNLcWVCeGZkSGVudjZ0WDhDdFlSQnFFaTM3ZjBkWUdhQWYxTWxyClBlaDVJUUtCZ1FDbmN6YU8xcUx3VktyeUc4TzF5ZUhDSjQzT1h6SENwN3VnOE90aS9ScmhWZ08wSCtEdVpXUzUKSWhydHpUeU56MExyQTdibVFLTWZ4Y3k5Y29LOG9zZnVma1pZenJxM1ZFa0ViUCtjRWdLcGtlTDlaY2RSbXZ3WQozSTZkMUlOWVUwMldPSzhiRUJBNElJNGc0ak9ZcjJJUjFzb2lWZ0E2YnVya3E3QnMrUm41WFE9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=' }

      let(:access_token) do
        JWT.encode({ data: 'some-data', iss: issuer_claim },
                   OpenSSL::PKey::RSA.new(Base64.strict_decode64(encoded_private_key)),
                   'RS256')
      end

      let(:json) do
        {
          token: encoded_public_key
        }.to_json
      end

      let(:configuration) { instance_double('configuration', auth_endpoint: 'http://example.com') }

      before do
        allow(Rails).to receive(:configuration).and_return(configuration)
        WebMock.stub_request(:get, "#{Rails.configuration.auth_endpoint}/service/v2/#{issuer_claim}").to_return(status: 200, body: json)
      end

      it 'works' do
        request.headers['x-access-token-v2'] = access_token
        post :create
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
