Rails.application.routes.draw do
  namespace :pants do
    resources :documents do
      collection do
        # Remote post viewer
        get 'remote/:url' => 'documents#remote', constraints: { url: /.+/ }
      end
    end

    resources :webmentions

    # Setup
    get  'setup' => 'setup#setup'
    post 'setup' => 'setup#setup'

    # Authentication
    match  'login' => 'auth#login', via: [:get, :post]
    delete 'login' => 'auth#logout'
  end

  # Posts
  get '*path' => 'pants/documents#show'

  root to: "pants/documents#index"
end
