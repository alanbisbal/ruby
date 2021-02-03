Rails.application.routes.draw do
  get 'invoices/index'
  get 'invoices/show'
  root to: "home#index"
  get 'home/index'
  devise_for :users

  resources :books
  put 'books/:id', controller: 'books', action: :update


  resources :notes
  get 'download_note',controller: 'notes', action: :download
  get 'downloadnotes_book',controller: 'books', action: :download_notes

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users do
    get 'download'
    # file: rails-generate-pdf/app/config/routes.rb
  root to: 'invoices#index'
  resources :invoices, only: [:index, :show]
  end
end
