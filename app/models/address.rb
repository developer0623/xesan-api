class Address < ActiveRecord::Base
  belongs_to :user

  def as_json(options = {})
    {
      id: id,
      street: street,
      street2: street2,
      city: city,
      state: state,
      zip: zip
    }
  end
end
