Rails.application.routes.draw do
  scope :api do
    resources :posts, only: [:index, :show, :create, :update, :destroy]
  end

  get ':year/:month/:day/:slug' => 'posts#show', as: 'nice_post'
  get ':id' => 'posts#show', as: 'uid'

  root to: "posts#index"
end
