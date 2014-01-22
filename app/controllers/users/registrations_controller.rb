class Users::RegistrationsController < Devise::RegistrationsController
  before_action only: :create do
    devise_parameter_sanitizer.for(:sign_up) do |params|
      params.permit :name,
      				:email,
                    :password,
                    :password_confirmation,
                    :language
    end
  end

  before_action only: :update do
    devise_parameter_sanitizer.for(:account_update) do |params|
      params.permit :name,
                    :email,
                    :password,
                    :password_confirmation,
                    :current_password,
                    :language
    end
  end
end
