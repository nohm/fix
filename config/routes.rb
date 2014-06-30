Fix::Application.routes.draw do
  root :to => "home#index"

  devise_for :users, :controllers => {:registrations => "users/registrations"}
  resources :users

  resources :broadcasts, :only => [:index, :new, :create, :destroy]
  match 'broadcast/disable/:id' => 'broadcasts#disable', :as => :disable_broadcast, :via => :get

  # Special routes for error reporting
  match 'report' => 'home#report', :as => :report, :via => :get
  match 'send_report' => 'home#send_report', :as => :send_report, :via => :post
end
