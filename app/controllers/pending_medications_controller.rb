require 'rmagick'

class PendingMedicationsController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin_user]
  before_action :require_auth, except: [:image]
  before_action :set_pending_medication, only: [:show, :update, :destroy, :image]

  def require_auth
    unless current_member
      return render json: {
        errors: ["Authorized users only."]
      }, status: 401
    end
  end

  def index
    @meds = PendingMedication.where(%Q{status = 'new'}).all

    render json: @meds
  end

  def create
    @pending_medication = PendingMedication.new(params.require(:pending_medication).permit!)
    @pending_medication.status = 'new'
    @pending_medication.user = current_user

    if @pending_medication.save
      render json: @pending_medication, status: :created
    else
      render json: @pending_medication.errors, status: :unprocessable_entity
    end
  end

  def create_med_or_refill
    @pending_med = PendingMedication.find_by(id: params[:pending_med_id])
    if @pending_med.status != 'new'
      render json: {'error-message': 'Cannot create new medication! Pending status is not NEW.'}, status: :unprocessable_entity
      return;
    end
    @medication = Medication.new(medication_params)
    @medication.user_id = @pending_med.user_id unless @medication.user_id

    if refill_params
      @refill = RefillInfo.new(refill_params)
      @refill.active_refill = true

      if @medication.id
        @refill.medication_id = @medication.id
      else
        @medication.refills << @refill
      end
    end

    ActiveRecord::Base.transaction do
      unless @medication.id
        @saved = @medication.save
        @errors = @medication.errors
      else
        @saved = @refill.save
        @errors = @refill.errors
      end
      #AL: we don't delete pending med records here.
      #    so that it can be verified for any reason later.
      #    The records should be eventually deleted through maintenance
      #    process when they are no relevant.
      #@pending_med.destroy
      @pending_med.update(status: 'converted')
    end

    if @saved
      notification = {
        alert: "Your Medication is Ready",
        category: 'med-ready',
        custom: {
          medId: @medication.id
        }
      }
      MedicationReadyJob.new.delay.perform(@medication.user.device_tokens, notification)
      render json: @medication, status: :created
    else
      render json: @errors, status: :unprocessable_entity
    end
  end

  def image
    idx = params[:idx].to_i
    base64 = @pending_medication.images[idx]
    @image_data = Magick::Image.read_inline(base64)[0].auto_orient
    send_data @image_data.to_blob, :type => 'image/jpeg', disposition: 'inline'
  end

  def show
    render json: @pending_medication
  end

  def destroy
    @pending_medication.destroy

    head :no_content
  end

  private
    def set_pending_medication
      @pending_medication = PendingMedication.find(params[:id])
    end

    def pending_medication_params
      params.require(:pending_medication).permit(:name, :dose, :frequency, :strength, :rx_num, :refills_remaining, :discard_date, :reason_for_taking)
    end

    def medication_params
      params.require(:medication).permit(:id, :name, :dose, :frequency, :frequency_period, :strength, :refill, :refills_remaining, :discard_date, :reason_for_taking, :prescriber_id, :pharmacy_id, :form, :count, :route, :category, :description, :instructions, :ndc, :user_id)
    end

    def refill_params
      params[:medication][:refill].permit(:rx_number, :rx_fill_date, :refill_num, :refill_total, :current_med_count, :days_supply, :discard_date, :refills_expiration, :created_at, :active_refill)
    end
end
