class Medication < ActiveRecord::Base
  belongs_to :user
  belongs_to :pharmacy, class_name: "Pharmacy", foreign_key: "pharmacy_id"
  belongs_to :prescriber, class_name: "Provider"
  has_many :reminders, dependent: :destroy
  has_many :med_entries, dependent: :destroy
  has_many :refills, class_name: "RefillInfo", dependent: :destroy

  accepts_nested_attributes_for :reminders, :refills, allow_destroy: true

  after_save :associate_provider_user

  def associate_provider_user
    if user
      user.providers << prescriber if prescriber && !user.providers.exists?(prescriber.npi)
      user.providers << pharmacy if pharmacy && !user.providers.exists?(pharmacy.npi)
      user.save if prescriber || pharmacy
    end
  end

  def active_refill
    refills.where(active_refill: true).first
  end

  def as_json(options = {})
    json = {
      id: id,
      name: name,
      strength: strength,
      refillsRemaining: refills_remaining,
      dose: dose,
      frequency: frequency,
      frequencyPeriod: frequency_period,
      form: form,
      count: count,
      route: route,
      category: category,
      description: description,
      instructions: instructions,
      ndc: ndc,
      prescriber: prescriber,
      pharmacy: pharmacy,
      refills: refills,
      reminders: reminders
    }

    return json
  end
end
