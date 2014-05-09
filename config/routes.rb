Badger::Application.routes.draw do
  root :to => "home#index"

  devise_for :users, :controllers => {:registrations => "users/registrations"}
  resources :users

  resources :companies, :only => [:index, :new, :create, :edit, :update, :destroy] do
    resources :types, :only => [:index, :new, :create, :edit, :update, :destroy]
    resources :stocks, :only => [:index, :new, :create, :edit, :update, :destroy]
    resources :invoices, :only => [:index, :show, :new, :create, :destroy]
    resources :shipments do
      resources :stats, :only => :index
      resources :entries do
        resources :attachments, :only => [:create, :destroy]
      end
    end
  end

  match 'companies/:company_id/types/:apptype_id/stock' => 'stocks#type_stock', :as => :type_stock, :via => :get
  match 'companies/:company_id/types/:apptype_id/stock/index' => 'stocks#type_stock_index', :as => :type_stock_index, :via => :get
  match 'companies/:company_id/types/:apptype_id/stock/add/:stock_id' => 'stocks#type_stock_add', :as => :type_stock_add, :via => :get
  match 'companies/:company_id/types/:apptype_id/stock/remove/:stock_id' => 'stocks#type_stock_remove', :as => :type_stock_remove, :via => :delete

  # Special routes for batch updating
  match 'companies/:company_id/batch' => 'home#batch', :as => :batch, :via => :get
  match 'companies/:company_id/batch' => 'home#batch_update', :as => :batch_update, :via => :post

  # Special routes for entries
  match 'companies/:company_id/shipments/:shipment_id/entries/:id/sticker' => 'entries#sticker', :as => :sticker, :via => :get
  match 'companies/:company_id/shipments/:shipment_id/entries/:id/ticket' => 'entries#ticket', :as => :ticket, :via => :get
  match 'companies/:company_id/shipments/:shipment_id/entries/:id/zip' => 'entries#zip', :as => :zip, :via => :get

  resources :appliances, :only => [:index, :new, :create, :destroy]
  resources :classifications, :only => [:index, :new, :create]

  resources :broadcasts, :only => [:index, :new, :create, :destroy]
  match 'broadcast/disable/:id' => 'broadcasts#disable', :as => :disable_broadcast, :via => :get

  # Special routes for error reporting
  match 'report' => 'home#report', :as => :report, :via => :get
  match 'send_report' => 'home#send_report', :as => :send_report, :via => :post
end
