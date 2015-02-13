Rails.application.routes.draw do
  scope :pants do
    resources :documents
    resources :webmentions

    # Setup
    get  'setup' => 'pants/setup#setup'
    post 'setup' => 'pants/setup#setup'

    # Authentication
    match  'login'  => 'pants/auth#login', via: [:get, :post]
    delete 'login' => 'pants/auth#logout'
  end

  # Posts
  get ':year/:month/:day/:slug' => 'documents#show', as: 'nice_document'
  get ':id' => 'documents#show', as: 'uid'

  root to: "documents#index"
end
