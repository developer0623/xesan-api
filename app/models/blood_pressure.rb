class BloodPressure < ActiveRecord::Base
  belongs_to :user

  def as_json(options = {})
    {
      id: id,
      systolic: systolic,
      diastolic: diastolic,
      createdAt: created_at
    }
  end
end
