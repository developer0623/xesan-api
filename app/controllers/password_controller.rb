#reset a password
class PasswordController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin_user, :provider_user]
  before_action :validate_reset_request

  layout "application"

  def reset
    @token = params[:token]
    @client_id = params[:client_id]
    @user = User.find_by(email: params[:uid])

    #instead of messing up devise.rb format, simply hard-code format.
    render :action => 'reset.html.erb'
  end

  def validate_reset_request
    #stop right here if the request is not valid
    #token, uid should be required.
    params.require(:token)
    params.require(:client_id)
    params.permit(:config, :expiry, :reset_password, :uid, :format)
    #not sure about validating token/email, skip for now.
  end
end
