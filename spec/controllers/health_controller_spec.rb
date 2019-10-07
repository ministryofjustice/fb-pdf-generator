require 'rails_helper'

RSpec.describe HealthController do
  it 'works' do
    get :show
    expect(response).to be_successful
  end
end
