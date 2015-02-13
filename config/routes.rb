Rails.application.routes.draw do
  scope :pants do
    resources :documents
    resources :webmentions

    # Setup
    get  'setup' => 'setup#setup'
    post 'setup' => 'setup#setup'

    # Authentication
    match  'login'  => 'auth#login', via: [:get, :post]
    delete 'login' => 'auth#logout'
  end

  # Posts
  get ':year/:month/:day/:slug' => 'documents#show', as: 'nice_document'
  get ':id' => 'documents#show', as: 'uid'

  root to: "documents#index"
end
