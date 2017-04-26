class UsersController < ApplicationController
  def is_email_unique
    render json: {
      valid: User.find_by(email: params[:email]).nil?
    }
  end
end
