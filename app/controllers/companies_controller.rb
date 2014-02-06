class CompaniesController < ApplicationController
  before_filter :authenticate_user!

  def new
    authorize! :new, Company, :message => I18n.t('global.unauthorized')

    @company = Company.new
  end

  def index
    authorize! :index, Company, :message => I18n.t('global.unauthorized')

    @companies = Company.all.page(params[:page]).order('id ASC').per(25)
  end

  def create
    authorize! :create, Company, :message => I18n.t('global.unauthorized')

    @company = Company.new(params[:company].permit(:title,:short,:abb,:address))

    if @company.save
      redirect_to companies_path, :notice => I18n.t('company.model.company_added')
    else
      render 'new'
    end
  end

  def destroy
    authorize! :destroy, Company, :message => I18n.t('global.unauthorized')

    company = Company.find(params[:id])
    company.destroy
    redirect_to companies_path, :notice => I18n.t('company.model.compan_deleted')
  end
  
end

