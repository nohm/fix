Fix::Application.routes.draw do
  root :to => "home#index"

  devise_for :users, :controllers => {:registrations => "users/registrations"}
  resources :users

  resources :clients do
  	resources :repairs
  end

  match 'clients/:client_id/repairs/:id/print' => 'repairs#print', :as => :print, :via => :get

  resources :broadcasts, :only => [:index, :new, :create, :destroy]
  match 'broadcast/disable/:id' => 'broadcasts#disable', :as => :disable_broadcast, :via => :get

  # Special routes for error reporting
  match 'report' => 'home#report', :as => :report, :via => :get
  match 'send_report' => 'home#send_report', :as => :send_report, :via => :post
end
