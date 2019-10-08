require 'rails_helper'

RSpec.describe PdfGeneratorController, type: :request do
  let(:payload) do
    {
      submission_id: 'abc123'
    }
  end

  before do
    post '/v1/pdf', params: payload
  end

  it 'returns the correct Content-Type headers' do
    expect(response.headers['Content-Type']).to include('application/pdf')
  end

  it 'returns the correct Content-Disposition headers' do
    expect(response.headers['Content-Disposition']).to include("attachment; filename=receipt-#{payload[:submission_id]}.pdf")
  end

  it 'contains the submission details' do
    expect(response.headers['Content-Disposition']).to include("attachment; filename=receipt-#{payload[:submission_id]}.pdf")
  end
end
