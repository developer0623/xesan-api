class AdminUser < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
          # :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  def as_json(options = {})
    {
      id: id,
      firstName: first_name,
      lastName: last_name,
      email: email
    }
  end
end
