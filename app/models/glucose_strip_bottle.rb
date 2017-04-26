class GlucoseStripBottle < ActiveRecord::Base
  belongs_to :user
  validates :strip_count, numericality: { only_integer: true }

  def as_json(options = {})
    {
      stripCount: strip_count,
      expiration: expiration,
      opened: opened,
      lotNumber: lot_number,
      current: current
    }
  end
end
