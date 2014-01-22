Badger::Application.routes.draw do
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

  # Special routes for batch updating
  match 'batch' => 'home#batch', :as => :batch, :via => :get
  match 'batch' => 'home#batch_update', :as => :batch_update, :via => :post

  # Special routes for error reporting
  match 'report' => 'home#report', :as => :report, :via => :get
  match 'send_report' => 'home#send_report', :as => :send_report, :via => :post

  # Special routes for entries
  match 'entries/:id/sticker' => 'entries#sticker', :as => :sticker, :via => :get
  match 'entries/:id/zip' => 'entries#zip', :as => :zip, :via => :get
  match 'entries/:id/entryhistory' => 'entries#entryhistory', :as => :entryhistory, :via => :get
end
