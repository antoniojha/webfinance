Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  

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
end
