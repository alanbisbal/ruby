Rails.application.routes.draw do
  root to: "home#index"
  get 'home/index'
  devise_for :users

  resources :books
  put 'books/:id', controller: 'books', action: :update


  resources :notes
  get 'download' => 'downloader#download'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users do
    get 'download'

  end
end
