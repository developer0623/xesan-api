class PendingMedication < ActiveRecord::Base
  belongs_to :user


  def as_json(options = {})
    json = {
      id: id,
      userId: user_id,
      images: images,
      status: status,
      createdAt: created_at.strftime("%F"),
      updatedAt: updated_at
    }
    #AL: very inefficient to do this. I will replace it with raw query for v1.0
    json[:patientName] = user.first_name + ' ' + user.last_name if (user.first_name && user.last_name)

    json
  end
end
