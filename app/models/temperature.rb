class Temperature < ActiveRecord::Base
  belongs_to :user

  def as_json(options = {})
    {
      id: id,
      temperature: temperature,
      createdAt: created_at
    }
  end
end
