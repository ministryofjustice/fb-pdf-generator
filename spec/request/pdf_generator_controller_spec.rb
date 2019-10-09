require 'rails_helper'

RSpec.describe PdfGeneratorController, type: :request do
  it 'can be called' do
    post '/v1/pdf'
  end
end
