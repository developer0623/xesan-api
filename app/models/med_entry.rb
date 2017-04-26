class MedEntry < ActiveRecord::Base
  belongs_to :medication
  belongs_to :reminder

  def as_json(options = {})
    {
      id: id,
      medicationId: medication_id,
      userId: user_id,
      taken: taken,
      scheduledTime: scheduled_time,
      actualTime: actual_time
    }
  end
end
