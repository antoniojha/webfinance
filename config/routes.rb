Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  resources :advance_search
  resources :backgrounds
  controller :backgrounds do
    get 'add_assoc'=> :add_assoc
    get 'remove_assoc'=> :remove_assoc
  end
  controller :sessions do
    get 'login'=> :new
    post 'signin'=> :create
    delete 'logout'=> :destroy
   end
  resources :users
  controller :users do
    get 'signup'=> :new
  end
  match '/remove', to:'users#remove',via:'get'
  match'/admin/remove/:id', to:'users#admin_remove', via:'get', as: 'admin_remove'
  controller :static_pages do
    get "demo" => :demo
    get "contact" => :contact
    get "about" => :about
    get "home" => :home
    get "faq" => :faq
    get "blog" => :blog
  end
  root 'static_pages#home'
  
  resources :logs
  
  resources :select_banks
  controller :select_banks do
    get 'next_page1' => :next_page1
    get 'next_page2' => :next_page2
    get 'bank_login'=> :bank_login
    get 'account' => :account
  end
#    match '/bank_login',  to: 'select_banks#bank_login', via: :get
#  match '/account',  to: 'select_banks#account', via: :get

  match '/confirmation', to:'email_confirmation#new',via:'get'
  resources :email_confirmation
  get 'profiles/home'
  match '/profile', to: 'profiles#new', via: 'get'
  resources :spendings
  resources :transaction_imports
  controller :transaction_imports do
    get 'import' => :new
  end
end
