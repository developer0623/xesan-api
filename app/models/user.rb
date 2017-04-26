class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User

  # meds auto delete entries and reminders. don't do it here here
  has_many :medications, dependent: :destroy
  has_many :pending_medications, dependent: :destroy
  has_many :prescription_requests, dependent: :destroy

  # associated vitals
  has_many :blood_pressures, dependent: :destroy
  has_many :glucoses, dependent: :destroy
  has_many :pulse_oxygens, dependent: :destroy
  has_many :temperatures, dependent: :destroy
  has_many :weights, dependent: :destroy

  has_and_belongs_to_many :providers

  has_one :home_address, dependent: :destroy
  has_one :mailing_address, dependent: :destroy

  has_many :glucose_strip_bottles, dependent: :destroy

  has_one :insurance, dependent: :destroy

  accepts_nested_attributes_for :home_address, :mailing_address, :insurance

  def glucose_strip_bottle
    glucose_strip_bottles.where(current: true).first
  end

  def pending_reconfirmation?
    return false
  end

  def as_json(options = {})
    {
      id: id,
      firstName: first_name,
      lastName: last_name,
      email: email,
      height: height,
      weight: weight,
      gender: gender,
      dob: dob,
      deviceTokens: device_tokens,
      providers: providers.where(is_pharmacy: false),
      pharmacies: providers.where(is_pharmacy: true),
      homeAddress: home_address,
      mailingAddress: mailing_address,
      glucoseStripBottle: glucose_strip_bottle,
      insurance: insurance
    }
  end
end
