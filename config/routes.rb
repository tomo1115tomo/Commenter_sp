Rails.application.routes.draw do

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  get 'comments/new'
  post 'comments/create'
  get 'comments/index'
  post 'comments/create', as:"comments"
  get 'rooms/create'
  #get 'rooms/destroy'
  resources :rooms
  get 'friends/new'
  get 'friends/create'
  get 'friends/edit'
  get 'friends/destroy'
  namespace :admin do
    resources :users
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.htmls
  get '/users/my_profile/:id' => 'users#my_profile'

  resources :users
  get '/users/:id' =>'users#show'
  get '/' => 'users#index'

  mount ActionCable.server => '/cable'
end
