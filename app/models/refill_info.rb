class RefillInfo < ActiveRecord::Base
  belongs_to :medication

  after_save :update_active

  def update_active
    where = %Q{medication_id = :medication_id AND active_refill = TRUE AND id <> :id}
    where_params = {
      medication_id: medication_id,
      id: id
    }
    @refills = RefillInfo.where(where, where_params)
      .update_all(active_refill: false) if medication_id

    # increment the med count by the new # of meds
    if medication && medication.count && current_med_count && medication.refills.count > 0
      medication.count = medication.count + current_med_count
      medication.save
    end
  end

  def as_json(options = {})
    {
      id: id,
      rxNumber: rx_number,
      fillDate: rx_fill_date,
      number: refill_num,
      total: refill_total,
      currentMedCount: current_med_count,
      daysSupply: days_supply,
      discardDate: discard_date,
      expiration: refills_expiration,
      active: active_refill
    }
  end

end
