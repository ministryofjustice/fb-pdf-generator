Rails.application.routes.draw do
  scope 'v1' do
    resources :pdfs, only: [:create], format: :json
  end

  get '/health', to: 'health#show'
end
