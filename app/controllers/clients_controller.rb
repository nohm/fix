class ClientsController < ApplicationController
	def index
		authorize! :index, Client, :message => I18n.t('global.unauthorized')

		@clients = Client.all.order('id ASC').page(params[:page]).per(25)
		@pagination = true # move after implementing search
	end

	def new
    	authorize! :new, Client, :message => I18n.t('global.unauthorized')

		@client = Client.new
	end

	def create
    	authorize! :create, Client, :message => I18n.t('global.unauthorized')

    	@client = Client.new(params[:client].permit(:name,:phone_number,:mobile_phone_number,:email_address,:postal_code,:house_number,:street,:city))
	    if @client.save
	      redirect_to clients_path, :notice => 'Client added.'
	    else
	      render 'new'
	    end
	end

	def edit
		authorize! :edit, Client, :message => I18n.t('global.unauthorized')

		@client = Client.find(params[:id])
	end

	def update
		authorize! :update, Client, :message => I18n.t('global.unauthorized')

		@client = Client.find(params[:id])
	    if @client.update(params[:client].permit(:name,:phone_number,:mobile_phone_number,:email_address,:postal_code,:house_number,:street,:city))
	      redirect_to clients_path, :notice => 'Client updated.'
	    else
	      render 'edit'
	    end
	end

end
