class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :rerequest_facebook_email, only: [:facebook]

  def facebook
    oauth_process :facebook
  end

  def google_oauth2
    oauth_process :google
  end

  def failure
    redirect_to root_path
  end

  private
    def oauth_process(provider)
      provider = provider.to_s
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => provider.titleize) if is_navigational_format?
      else
        session["devise.#{provider.underscore}_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end

    def rerequest_facebook_email
      if request.env["omniauth.auth"].info.email.blank?
        redirect_to omniauth_authorize_path(:user, :facebook, auth_type: :rerequest, scope: :email)
      end
    end
end
