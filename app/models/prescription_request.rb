class PrescriptionRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :provider
  belongs_to :medication

  #this is a quick dirty way to get everything I need for xenprov
  def as_json(options = {})
    glucoses = Glucose.where(%Q{user_id=#{user_id}}).order(:created_at);
    ActiveRecord::Base.include_root_in_json = false
    json = {
      id: id,
      pid: user_id,
      physicianId: provider_id,
      requestDate: created_at.strftime("%m/%d/%Y"),
      status: status,
      note: note,
      pharmacy: medication.pharmacy,
      bgm: glucoses
    }

    json[:dob] = user.dob.strftime("%m/%d/%Y") if user.dob
    json[:remainingDays] =  (end_date - Date.parse(Time.now.to_s)).to_i if end_date
    json[:patientName] = (user.first_name + ' ' + user.last_name) if (user.first_name && user.last_name)
    json[:rxName] = medication.name + (' (' + medication.ndc + ')' if (medication.ndc))

    return json
  end

end



