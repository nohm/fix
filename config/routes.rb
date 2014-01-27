Badger::Application.routes.draw do
  get "broadcast/index"
  get "broadcast/new"
  root :to => "home#index"

  devise_for :users, :controllers => {:registrations => "users/registrations"}

  resources :users
  resources :entries do
  	resources :attachments
  end
  resources :invoices
  resources :appliances
  resources :classifications
  resources :history
  resources :stats
  resources :broadcasts

  match 'broadcast/retrieve' => 'broadcasts#retrieve', :as => :retrieve_broadcasts, :via => :get
  match 'broadcast/disable' => 'broadcasts#disable', :as => :disable_broadcast, :via => :get

  # Special routes for batch updating
  match 'batch' => 'home#batch', :as => :batch, :via => :get
  match 'batch' => 'home#batch_update', :as => :batch_update, :via => :post

  # Special routes for error reporting
  match 'report' => 'home#report', :as => :report, :via => :get
  match 'send_report' => 'home#send_report', :as => :send_report, :via => :post

  # Special routes for entries
  match 'entries/:id/sticker' => 'entries#sticker', :as => :sticker, :via => :get
  match 'entries/:id/ticket' => 'entries#ticket', :as => :ticket, :via => :get
  match 'entries/:id/zip' => 'entries#zip', :as => :zip, :via => :get
  match 'entries/:id/entryhistory' => 'entries#entryhistory', :as => :entryhistory, :via => :get
end
