class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => I18n.t('global.unauth_admin')
    @users = User.all.page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
  end
  
  def update
    authorize! :update, @user, :message => I18n.t('global.unauth_admin')
    @user = User.find(params[:id])
    if @user.update_attributes(params.require(:user).permit(:role_ids))
      Mailer.send_role_update(@user).deliver!
      redirect_to users_path, :notice => I18n.t('user.controller.update_success')
    else
      redirect_to users_path, :alert => I18n.t('user.controller.update_fail')
    end
  end
    
  def destroy
    authorize! :destroy, @user, :message => I18n.t('global.unauth_admin')
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => I18n.t('user.controller.delete_success')
    else
      redirect_to users_path, :notice => I18n.t('user.controller.delete_fail')
    end
  end

end
