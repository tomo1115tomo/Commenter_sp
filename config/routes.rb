Rails.application.routes.draw do

  get '/' => 'users#index'

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

  post 'rooms/create'

  get 'friends/new'
  get 'friends/create'
  get 'friends/edit1'
  get 'friends/edit2'
  delete 'friends/destroy'
  namespace :admin do
    resources :users
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.htmls

  resources :users
  get '/users/:id' =>'users#show'

  mount ActionCable.server => '/cable'
end
