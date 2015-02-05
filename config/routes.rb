Rails.application.routes.draw do
  scope :api do
    resources :posts
  end

  # Setup
  get  'setup' => 'setup#setup'
  post 'setup' => 'setup#setup'

  # Authentication
  match 'login'  => 'auth#login', via: [:get, :post]
  post  'logout' => 'auth#logout'

  # Posts
  get ':year/:month/:day/:slug' => 'posts#show', as: 'nice_post'
  get ':id' => 'posts#show', as: 'uid'

  root to: "posts#index"
end
