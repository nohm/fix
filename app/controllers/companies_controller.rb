class CompaniesController < ApplicationController
  before_filter :authenticate_user!

  def new
    authorize! :new, Company, :message => I18n.t('global.unauthorized')

    @company = Company.new
  end

  def index
    authorize! :index, Company, :message => I18n.t('global.unauthorized')

    @companies = Company.all.page(params[:page]).order('id ASC').per(25)

    @companies.each do |company|
      entries = Entry.where(company: company.short)
      entries.each do |entry|
        entry.update_attribute(:company_id, company.id)
      end
      invoices = Invoice.where(company: company.short)
      invoices.each do |invoice|
        invoice.update_attribute(:company_id, company.id)
      end
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

