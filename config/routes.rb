Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  resources :advance_search
  resources :broker_search
  resources :protection_plans

  resources :plans
  controller :plans do

    get "debt_2"=> :debt_2
    get "emergency_3"=> :emergency_3
    get "retirement_4"=> :retirement_4
    get "education_5"=> :education_5
    get "saving_6"=> :saving_6
    get "start"=> :start
  end
  resources :backgrounds
  controller :backgrounds do
    get 'add_assoc'=> :add_assoc
    get 'remove_assoc'=> :remove_assoc
    get 'info'=> :info
    get 'direct_to'=> :direct_to
  end
  resources :brokers
  controller :brokers do
    get "broker/new2"=> :new2
    get "broker/finish"=> :finish
    get "broker/review_index"=> :review_index
    get "close_finish"=> :close_finish
  end
  resources :status_sessions, only: [:new,:create,:destroy,:show]
  
  resources :goals
  controller :sessions do
    get 'login'=> :new
    post 'signin'=> :create
    delete 'logout'=> :destroy
   end
  resources :users
  controller :users do
    get 'signup'=> :new
    get 'crop'=> :crop
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
    get 'template' => :template
  end
  resources :broker_imports
end
