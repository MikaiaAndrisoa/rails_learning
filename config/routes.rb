Rails.application.routes.draw do

  get 'admin' => 'admin#index'

  controller :sessions do
   
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy

  end
  
  root 'store#index', as: 'store_index'

  resources :users
  resources :orders
  resources :line_items
  resources :carts
  resources :photos
  
  resources :products do

    get :who_bought, on: :member
  
  end
  
  
  get 'admin/index'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  
# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end