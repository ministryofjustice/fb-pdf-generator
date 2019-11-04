require 'rails_helper'

RSpec.describe PdfsController, type: :request do
  include_context 'when authentication required' do
    let(:url) { '/v1/pdfs' }

    before do
      Timecop.freeze(Time.parse('2019-10-10 15:43:54 +0000'))
      post url, params: payload.to_json, headers: auth_headers
    end

    after do
      Timecop.return
    end

    it 'can be requested' do
      expect(response).to have_http_status(:ok)
    end

    let(:payload) do
      {
        submission_id: '1786c427-246e-4bb7-90b9-a2e6cfae003f',
        pdf_heading: 'Complain about a court or tribunal',
        pdf_subheading: 'A copy of your complaint for your records',
        sections: [
          {
            heading: 'What is the name you wish to appear on your certificate',
            summary_heading: 'Your Name',
            questions: [
              {
                label: 'First name',
                answer: 'Bob'
              },
              {
                label: 'Last name',
                answer: 'Smith'
              }
            ]
          }, {
            heading: 'Contact Details',
            questions: [
              {
                label: 'Your email address',
                answer: 'bob.smith@gov.uk'
              }, {

                label: 'Your complaint',
                answer: 'tester content'
              }, {
                label: 'Court or tribunal your complaint is about',
                answer: 'Aberdeen Employment Tribunal'
              }
            ]
          }
        ]
      }
    end

    context 'without a subheading' do
      let(:payload) do
        {
          submission_id: '1786c427-246e-4bb7-90b9-a2e6cfae003f',
          pdf_heading: 'Complain about a court or tribunal',
          sections: []
        }
      end

      it 'subheading is optional' do
        expect(response.body).to be_truthy
      end
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

    it 'includes subheading' do
      analysis = PDF::Inspector::Text.analyze response.body
      expect(analysis.strings.join).to include('A copy of your complaint for your records')
    end

    it 'includes the questions in the pdf' do
      analysis = PDF::Inspector::Text.analyze response.body
      expect(analysis.strings.join).to include('First name')
    end

    it 'includes the answers in the pdf' do
      analysis = PDF::Inspector::Text.analyze response.body
      expect(analysis.strings.join).to include('Bob')
    end

    it 'includes the headers in the pdf' do
      analysis = PDF::Inspector::Text.analyze response.body
      expect(analysis.strings.join).to include('Complain about a court or tribunal')
    end

    it 'includes the summary heading when present' do
      analysis = PDF::Inspector::Text.analyze response.body
      expect(analysis.strings.join).to include('Your Name')
    end

    it 'includes the id' do
      analysis = PDF::Inspector::Text.analyze response.body
      expect(analysis.strings.join).to include(payload[:submission_id])
    end

    it 'creates a 1 page document' do
      analysis = PDF::Inspector::Page.analyze(response.body)
      expect(analysis.pages.size).to eq(1)
    end

    it 'shows page number in right footer' do
      analysis = PDF::Inspector::Text.analyze response.body
      expect(analysis.strings.join).to include('1/1')
    end

    it 'shows page number in left footer' do
      analysis = PDF::Inspector::Text.analyze response.body
      expect(analysis.strings.join).to include('1786c427-246e-4bb7-90b9-a2e6cfae003f /')
    end

    it 'shows date and time in left footer' do
      analysis = PDF::Inspector::Text.analyze response.body
      expect(analysis.strings.join).to include('10 Oct 2019 15:43:54 UTC')
    end
  end
end
