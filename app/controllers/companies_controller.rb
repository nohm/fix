class CompaniesController < ApplicationController
  before_filter :authenticate_user!

  def new
    authorize! :new, Company, :message => I18n.t('global.unauthorized')

    @company = Company.new
  end

  def index
    authorize! :index, Company, :message => I18n.t('global.unauthorized')

    @companies = Company.all.page(params[:page]).order('id ASC').per(25)

    entries = Entry.all
    entries.each do |e|
      if e[:company] == 'maxi-outlet'
        company = 'maxioutlet'
      else
        company = e[:company]
      end

      e.update_attribute(:company_id, Company.where(short: company).take.id)
    end

    invoices = Invoice.all
    invoices.each do |i|
      if i[:company] == 'maxi-outlet'
        company = 'maxioutlet'
      else
        company = i[:company]
      end
      i.update_attribute(:company_id, Company.where(short: company).take.id)
    end

  end

  def create
    authorize! :create, Company, :message => I18n.t('global.unauthorized')

    @company = Company.new(params[:company].permit(:title,:short,:abb,:adress))

    if @company.save
      redirect_to companies_path, :notice => 'Added'
    else
      render 'new'
    end
  end

  def destroy
    authorize! :destroy, Company, :message => I18n.t('global.unauthorized')

    company = Company.find(params[:id])
    company.destroy
    redirect_to companies_path, :notice => 'Deleted'
  end
  
end

