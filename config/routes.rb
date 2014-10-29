Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   controller :sessions do
    get 'login'=> :new
    get 'signin'=> :create
    delete 'logout'=> :destroy
   end
  controller :users do
    get 'signup'=> :new
  end

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
  resources :users
  resources :select_banks
  controller :select_banks do
    get "next_page1"=> :next_page1
  end


  
  match '/bank_login',  to: 'select_banks#bank_login', via: :get
end
