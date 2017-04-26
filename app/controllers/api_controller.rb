class ApiController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  devise_token_auth_group :member, contains: [:user, :admin_user, :provider_user]
  before_action :require_auth

  def require_auth
    unless current_member
      return render json: {
        errors: ["Authorized users only."]
      }, status: 401
    end
  end
end
