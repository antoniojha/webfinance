Rails.application.routes.draw do
  resources :private_messages

  resources :activities
  controller :activities do
    get "news" => :index
    
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  resources :financial_goal_story_rels
  resources :micro_comments
  resources :financial_testimonies
  resources :financial_stories
  resources :financial_products
  resources :licenses
  
  resources :experiences
  resources :educations
  get 'licenses/:id' => 'setup_brokers#download', :as => :download
  resources :setup_brokers

  resources :identities
  controller :authentication_out do
    get 'facebook'=> :facebook
    get 'linkedin'=> :linkedin
    get 'googleplus'=> :googleplus
    get 'twitter'=> :twitter
  end
  resources :authentication_in
  controller :authentication_in do
    get 'failure'=>:failure
  end
  get 'auth/:provider/callback', to: 'authentication_in#create'
  get '/auth/failure', :to => 'authentication_in#failure'
#  get 'auth/:provider/callback', to: 'broker/sessions#create'
#  get '/auth/failure', :to => 'broker/sessions#failure'
  get '/logout', :to => 'user/sessions#destroy', :as => 'logout'
  resources :advices
  resources :advice_categories
  resources :advance_search
  resources :broker_search  
  resources :schedules
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
  resources :schedule_sessions, only:[:create,:delete]
  resources :brokers
 # match'/register/brokers/new', to:'brokers#new', via:'get', as: 'new'
 # get 'register/brokers/new'=> 'brokers#new'
  controller :brokers do
    get "broker/home/:id" => :home, as: 'broker_home'
    get ":id/edit2"=> :edit2, as:"edit2_broker"
    get "add_license" => :add_license
    get 'crop'=> :crop
    get "brokers/licenses/:id" => :licenses, as:"broker_licenses"
    get "brokers/products/:id" => :products, as:"broker_products"
  end

  
  namespace :admin do
    resources :product_relations, controller: 'product_fin_category_rels'
    resources :companies
    resources :products
    resources :broker_requests
    controller :admin_pages do
      get "home" => :index
    end
  #  resources :brokers
  #  resources :application_comments
  #  resources :authenticated
  end
  namespace :register do
    resources :brokers
    controller :brokers do
      get 'signup'=> :new
      get "status/:id"=> :status, as:"broker_status"
      get "finish/:id"=> :finish, as:"broker_finish"
      get "close_finish"=> :close_finish
    end
  end
  resources :temp_brokers
  namespace :user do
    resources :authenticated
    controller :sessions do
    get 'login'=> :new
    get 'password_prompt'=> :password_prompt
    get 'password_lookup/:id'=> :edit, as:"password_lookup"
    post 'signin'=> :create
    patch 'send_validation'=> :update
    delete 'logout'=> :destroy

   end
   # resources :sessions, only:[:new,:create]
  end
  namespace :broker do
    controller :sessions do
      get 'login'=> :new
      post "signin"=> :create
      delete "logout"=> :destroy
    end

  end
  controller :brokers do
    get 'broker/signup'=> :new
  end

  resources :quote_relations
  controller :quote_relations do
    get 'quote_lists'=> :quote_lists
  end
  resources :status_sessions, only: [:new,:create,:destroy]
  
  resources :goals

  resources :users
  controller :users do
    get 'signup'=> :new
    get 'crop'=> :crop
    get 'user/home/:id'=> :home, as: 'user_home'
  end
  resources :setups
  controller :setups do
    get 'setup/:id'=> :edit, as: 'custom_edit_setup'
  end
  match '/users/remove/:id', to:'users#remove',via:'get', as: 'user_remove'
  match '/brokers/remove/:id', to:'brokers#remove',via:'get', as: 'broker_remove'
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
