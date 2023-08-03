require 'rails_helper'

RSpec.describe PdfsController, type: :request do
  include_context 'when authentication required' do
    let(:url) { '/v1/pdfs' }

    before do
      Timecop.freeze(Time.parse('2019-10-10 15:43:54 +0000'))
      post url, params: payload, headers: auth_headers, as: :json
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
                human_value: 'Bob',
                answer: 'bob'
              },
              {
                label: 'Last name',
                human_value: 'Smith',
                answer: 'smith'
              }
            ]
          }, {
            heading: 'Contact Details',
            questions: [
              {
                label: 'Your email address',
                human_value: 'bob.smith@gov.uk',
                answer: 'bob.smith@gov.uk'
              }, {

                label: 'Your complaint',
                human_value: 'tester content',
                answer: 'testing answer with % character'
              }, {
                label: 'Court or tribunal your complaint is about',
                human_value: 'Aberdeen Employment Tribunal',
                answer: '101'
              }
            ]
          }
        ]
      }
    end

    context 'without a heading or subheading' do
      let(:payload) do
        {
          submission_id: '1786c427-246e-4bb7-90b9-a2e6cfae003f',
          sections: []
        }
      end

      it 'still generates the PDF' do
        expect(response.body).to be_truthy
      end
    end

    context 'without a subheading' do
      let(:payload) do
        {
          submission_id: '1786c427-246e-4bb7-90b9-a2e6cfae003f',
          pdf_heading: 'Complain about a court or tribunal',
          sections: []
        }
      end

      it 'still generates the PDF' do
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

    it 'prefers the human readable answer' do
      analysis = PDF::Inspector::Text.analyze response.body
      expect(analysis.strings.join).to include('Aberdeen Employment Tribunal')
    end

    it 'fallbacks to the answers key in the pdf if human_value not defined' do
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

    # it 'shows page number in left footer' do
    #   analysis = PDF::Inspector::Text.analyze response.body
    #   expect(analysis.strings.join).to include('1786c427-246e-4bb7-90b9-a2e6cfae003f /')
    # end

    # it 'shows date and time in left footer' do
    #   byebug
    #   analysis = PDF::Inspector::Text.analyze response.body
    #   expect(analysis.strings.join).to include('10 Oct 2019 15:43:54 UTC')
    # end

    context 'with special characters' do
      let(:payload) do
        {
          submission_id: '1786c427-246e-4bb7-90b9-a2e6cfae003f',
          pdf_heading: 'Complain about a court or tribunal',
          sections: [
            {
              heading: 'Contact Details',
              questions: [
                {
                  label: 'Your complaint',
                  human_value: 'My cat is named £ % ~ ! # $ & ^ * ( ) - _ = + [ ] { } | ; , . ? " < >',
                  answer: 'testing answer with special characters'
                }
              ]
            }
          ]
        }
      end

      it 'shows special characters' do
        analysis = PDF::Inspector::Text.analyze response.body
        expect(analysis.strings.join).to include('My cat is named £ % ~ ! # $ & ^ * ( ) - _ = + [ ] { } | ; , . ? " < >')
      end
    end
  end
end
