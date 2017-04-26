class Reminder < ActiveRecord::Base
  belongs_to :medication
  belongs_to :user

  has_many :med_entries

  accepts_nested_attributes_for :med_entries, allow_destroy: true

  def as_json(options = {})
    json = {
      id: id,
      guid: guid,
      startDate: start_date,
      endDate: end_date,
      deleted: deleted,
      hour: hour,
      minute: minute,
      sunday: sunday,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday,
      entries: {}
    }
    med_entries.each do |entry|
      json[:entries][entry.scheduled_time] = entry
    end

    json
  end

end
