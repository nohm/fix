Badger::Application.routes.draw do
  get "broadcast/index"
  get "broadcast/new"
  root :to => "home#index"

  devise_for :users, :controllers => {:registrations => "users/registrations"}

  resources :users
  resources :companies do
    resources :stats, :only => :index
    resources :invoices
    resources :entries do
  	  resources :attachments
    end
  end
  resources :appliances
  resources :classifications
  resources :history
  resources :broadcasts

  match 'broadcast/disable/:id' => 'broadcasts#disable', :as => :disable_broadcast, :via => :get

  # Special routes for batch updating
  match 'companies/:company_id/batch' => 'home#batch', :as => :batch, :via => :get
  match 'companies/:company_id/batch' => 'home#batch_update', :as => :batch_update, :via => :post

  # Special routes for error reporting
  match 'report' => 'home#report', :as => :report, :via => :get
  match 'send_report' => 'home#send_report', :as => :send_report, :via => :post

  # Special routes for entries
  match 'companies/:company_id/entries/:id/sticker' => 'entries#sticker', :as => :sticker, :via => :get
  match 'companies/:company_id/entries/:id/ticket' => 'entries#ticket', :as => :ticket, :via => :get
  match 'companies/:company_id/entries/:id/zip' => 'entries#zip', :as => :zip, :via => :get
  match 'companies/:company_id/entries/:id/entryhistory' => 'entries#entryhistory', :as => :entryhistory, :via => :get
end
