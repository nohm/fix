Badger::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  resources :entries do
  	resources :attachments
  end
  resources :invoices
  resources :appliances
  match 'entries/:id/sticker' => 'entries#sticker', :as => :sticker, :via => :get
  match 'entries/:id/zip' => 'entries#zip', :as => :zip, :via => :get
  match 'entries/search' => 'entries#search', :as => :search, :via => :get
end
