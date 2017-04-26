class Glucose < ActiveRecord::Base
  belongs_to :user

  def as_json(options = {})
    {
      id: id,
      value: value,
      activities: activities,
      notes: notes,
      createdAt: created_at,
      isControl: is_control
    }
  end

end
