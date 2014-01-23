class ClassificationsController < ApplicationController
  before_filter :authenticate_user!

  def new
    authorize! :new, Classifications, :message => I18n.t('global.unauthorized')

    @classification = Classifications.new
  end

  def index
    authorize! :index, Classifications, :message => I18n.t('global.unauthorized')

    @classifications = Classifications.all.page(params[:page]).per(25)
  end

  def create
    authorize! :create, Classifications, :message => I18n.t('global.unauthorized')

    @classification = Classifications.new(params[:classification].permit(:name))

    if @classification.save
      redirect_to classifications_path, :notice => I18n.t('classes.controller.notice_added')
    else
      render 'new'
    end
  end
  
end

