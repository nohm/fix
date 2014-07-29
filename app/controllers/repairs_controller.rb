class RepairsController < ApplicationController
	def index
    	authorize! :index, Repair, :message => I18n.t('global.unauthorized')

    	@repairs = Repair.where(client_id: params[:client_id]).order('id ASC').page(params[:page]).per(25)
    	@pagination = true # move after implementing search
    	@client = Client.find(params[:client_id])
	end

	def show
		authorize! :show, Repair, :message => I18n.t('global.unauthorized')

    	@repair = Repair.find(params[:id])
    	@client = Client.find(params[:client_id])
	end

	def print
		authorize! :print, Repair, :message => I18n.t('global.unauthorized')

    	@repair = Repair.find(params[:id])
    	@client = Client.find(params[:client_id])

    	@costs = Hash.new
        @costs[:basic] = Hash.new
    	if @repair.costs.presence
    		@costs[:basic][:labour] = @repair.costs
            @costs[:basic][:material] = @repair.costs
    		@costs[:full] = (@costs[:basic][:labour].to_i + @costs[:basic][:material].to_i) * 1.21
    		@costs[:vat] = @costs[:full] - (@costs[:basic][:labour].to_i + @costs[:basic][:material].to_i)
    	else
    		@costs[:basic][:labour] = '0.00'
            @costs[:basic][:material] = '0.00'
    		@costs[:full] = '0.00'
    		@costs[:vat] = '0.00'
    	end

    	render 'print', :layout => false
	end

	def new
    	authorize! :new, Repair, :message => I18n.t('global.unauthorized')

    	@repair = Repair.new
    	@client = Client.find(params[:client_id])
	end

	def create
    	authorize! :create, Repair, :message => I18n.t('global.unauthorized')

    	params[:repair][:client_id] = params[:client_id]
    	params[:repair][:priority] = params[:repair][:priority].to_i
    	params[:repair][:status_id] = Repair.process_status

    	@repair = Repair.new(params[:repair].permit(:status_id,:costs,:costs_secondary,:brand,:type_number,:serial_number,:date_of_purchase,:warranty,:sales_receipt,:accessoires,:damage,:location,:iris_code,:after_repair_iris_code,:problem,:solution,:method_acquire,:method_return,:note,:priority,:client_id))
    	if @repair.save
	      redirect_to client_repairs_path(@repair.client_id), :notice => 'Repair added.'
	    else
	      render 'new'
	    end
	end

	def edit
		authorize! :edit, Repair, :message => I18n.t('global.unauthorized')

    	@repair = Repair.find(params[:id])
    	@client = Client.find(params[:client_id])
	end

	def update
		authorize! :update, Repair, :message => I18n.t('global.unauthorized')

    	params[:repair][:priority] = params[:repair][:priority].to_i
    	params[:repair][:status_id] = Repair.process_status

		@repair = Repair.find(params[:id])
		if @repair.update(params[:repair].permit(:status_id,:costs,:costs_secondary,:brand,:type_number,:serial_number,:date_of_purchase,:warranty,:sales_receipt,:accessoires,:damage,:location,:iris_code,:after_repair_iris_code,:problem,:solution,:method_acquire,:method_return,:note,:priority,:client_id))
	      redirect_to client_repairs_path(@repair.client_id), :notice => 'Repair updated.'
	    else
	      render 'edit'
	    end
	end
end
