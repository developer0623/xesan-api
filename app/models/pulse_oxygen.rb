class PulseOxygen < ActiveRecord::Base
  belongs_to :user

  def as_json(options = {})
    {
      id: id,
      pulseOxygen: pulse_oxygen,
      createdAt: created_at
    }
  end
end
