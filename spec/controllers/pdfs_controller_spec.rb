require 'rails_helper'

RSpec.describe PdfsController, type: :request do
  before do
    post '/v1/pdfs', params: payload
  end

  context 'with simple payload' do
    let(:payload) do {
        submission_id: 'd081415b-6bc6-4aab-b6f0-607b05bd44ee',
        pdf_heading: 'Claim for the costs of a childs funeral',
        pdf_subheading: '',
        sections: [
          {
            heading: 'Whats your address',
            summary_heading: '',
            questions: [
              {
                label: 'Building and street',
                answer: '9a St Marks Rise'
              },
              {
                label: 'Building and street line 2',
                answer: 'Dalston'
              }
            ]
          }
        ]
      }
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

    it 'sets the section heading and content' do
      analysis = PDF::Inspector::Text.analyze response.body
      expect(analysis.strings).to include('Hello world')
    end
  end

  context 'with pdf subheading and summary headings in payload' do
    let(:payload) do {
        submission_id: 'd081415b-6bc6-4aab-b6f0-607b05bd44ee',
        pdf_heading: 'Claim for the costs of a childs funeral',
        pdf_subheading: 'this is optional',
        sections: [
          {
            heading: 'Whats your address',
            summary_heading: 'Takes precendence if set, and heading becomes a subheading',
            questions: [
              {
                label: 'Building and street',
                answer: '9a St Marks Rise'
              },
              {
                label: 'Building and street line 2',
                answer: 'Dalston'
              }
            ]
          }
        ]
      }
    end

    it 'sets the pdf subheading' do
    end

    it 'sets the summary heading on the section' do
    end
  end
end
