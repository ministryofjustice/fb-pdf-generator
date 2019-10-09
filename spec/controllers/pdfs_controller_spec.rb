require 'rails_helper'

RSpec.describe PdfsController, type: :request do
  before do
    post '/v1/pdfs', params: payload
  end

  context 'with simple payload' do
    let(:payload) { { submission_id: 'd081415b-6bc6-4aab-b6f0-607b05bd44ee' } }

    it 'returns the correct Content-Type headers' do
      expect(response.headers['Content-Type']).to include('application/pdf')
    end

    it 'returns the correct Content-Disposition headers' do
      expect(response.headers['Content-Disposition']).to include("attachment; filename=receipt-#{payload[:submission_id]}.pdf")
    end

    it 'contains the submission details' do
      expect(response.headers['Content-Disposition']).to include("attachment; filename=receipt-#{payload[:submission_id]}.pdf")
    end

    it 'returns a hello world pdf' do
      analysis = PDF::Inspector::Text.analyze response.body
      expect(analysis.strings.join).to include('Hello world')
    end
  end
end
