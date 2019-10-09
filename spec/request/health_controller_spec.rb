require 'rails_helper'

RSpec.describe HealthController, type: :request do
  it 'can be requested' do
    get '/health'
    expect(response).to be_successful
  end

  it 'returns body' do
    get '/health'
    expect(response.body).to eq('healthy')
  end
end
