Rails.application.routes.draw do
  namespace :pants do
    resources :documents do
      collection do
        # Remote post viewer
        get 'remote/:url' => 'documents#remote', constraints: { url: /.+/ }
      end
    end

    resources :webmentions

    # User
    resource :user, only: [:show, :edit, :update]

    # Setup
    get  'setup' => 'setup#setup'
    post 'setup' => 'setup#setup'

    # Authentication
    match  'login' => 'auth#login', via: [:get, :post]
    delete 'login' => 'auth#logout'

    # Export
    get 'export' => 'users#export'

    # Catch-all route for everything else; we don't want users to create
    # documents underneath this namespace!
    match '*path' => '/application#render_404', via: :get
  end

  # Posts
  get '*path' => 'pants/documents#show'

  root to: "pants/documents#index"
end
