Rails.application.routes.draw do
  scope 'v1' do
    resources :pdf_generator, only: [:create], path: 'pdf'
  end

  get '/health', to: 'health#show'
end
