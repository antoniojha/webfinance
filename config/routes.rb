Rails.application.routes.draw do
  resources :financial_products

  resources :contacts, only:[:create]

  resources :user_searches

  resources :private_messages
  controller :private_messages do
    get "private_message/sent" => :sent, as: "private_message_sent"
  end
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

  resources :licenses
  
  resources :experiences
  resources :educations
  get 'licenses/:id' => 'setup_brokers#download', :as => :download
  resources :setup_brokers

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


  resources :advance_search
  resources :broker_search  
  resources :backgrounds
  controller :backgrounds do
    get 'add_assoc'=> :add_assoc
    get 'remove_assoc'=> :remove_assoc
    get 'info'=> :info
    get 'direct_to'=> :direct_to

  end
  resources :brokers

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
    resources :activities
    resources :companies
    resources :products
    resources :broker_requests
    controller :admin_pages do
      get "home" => :index
    end
  end

  namespace :user do
    resources :authenticated
    controller :sessions do
    get 'login'=> :new
    get 'password_prompt'=> :password_prompt
    get 'password_lookup/:id'=> :edit, as:"password_lookup"
    post 'signin'=> :create
    patch 'send_password'=> :update
    delete 'logout'=> :destroy

   end
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
  root 'static_pages#home'
  controller :static_pages do
    get "contact" => :contact
    get "about" => :about
    get "home" => :home
    get "faq" => :faq
    get "broker_background_check" => :broker_background_check
    get "broker_registration_criteria" => :broker_registration_criteria
  end
  scope '/legal' do
    controller :legal do
      get "user_agreement" => :user_agreement
      get "privacy_policy" => :privacy_policy
      get "disclaimer" => :disclaimer
      get "copyright_policy" => :copyright_policy
    end
  end
  
  
  resources :spendings
  resources :transaction_imports
  controller :transaction_imports do
    get 'import' => :new
    get 'template' => :template
  end

end
