Rails.application.routes.draw do
  scope :api do
    resources :documents
    resources :webmentions
  end

  # Setup
  get  'setup' => 'setup#setup'
  post 'setup' => 'setup#setup'

  # Authentication
  match 'login'  => 'auth#login', via: [:get, :post]
  post  'logout' => 'auth#logout'

  # Posts
  get ':year/:month/:day/:slug' => 'documents#show', as: 'nice_document'
  get ':id' => 'documents#show', as: 'uid'

  root to: "documents#index"
end
