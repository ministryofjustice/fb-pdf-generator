require 'rails_helper'

RSpec.describe PdfGeneratorController, type: :request do
  it 'has a placeholder url' do
    post '/v1/pdf'
  end
end
