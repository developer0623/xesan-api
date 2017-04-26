class Weight < ActiveRecord::Base
  belongs_to :user

  def as_json(options = {})
    {
      id: id,
      weight: weight,
      createdAt: created_at
    }
  end
end
