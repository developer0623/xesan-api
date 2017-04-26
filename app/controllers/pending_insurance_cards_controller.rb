require 'rmagick'

class PendingInsuranceCardsController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin_user]
  before_action :require_auth, except: [:image]
  before_action :set_pending_insurance_card, only: [:show, :needMoreInfo, :update, :destroy, :image]

  def require_auth
    unless current_member
      return render json: {
        errors: ["Authorized users only."]
      }, status: 401
    end
  end

  def index
    pendingCards = PendingInsuranceCard.where(%Q{status = 'new'}).all

    render json: pendingCards
  end

  def create
    @pending_card = PendingInsuranceCard.new(params.require(:pending_insurance_card).permit!)
    @pending_card.status = 'new'
    @pending_card.user = current_user

    if @pending_card.save
      render json: @pending_card, status: :created
    else
      render json: @pending_card.errors, status: :unprocessable_entity
    end
  end

  def needMoreInfo
    @pending_insurance_card.update(status: 'need more info')

    notification = {
      alert: "Your insurance info is NOT complete, please submit again.",
      category: 'ins-more-info',
      custom: {
        insId: @pending_insurance_card.id
      }
    }
    MedicationReadyJob.new.delay.perform(@pending_insurance_card.user.device_tokens, notification)

    render json: @pending_insurance_card, status: :created
  end

  def update
    new_ins = insurance_card_params
    insurance = Insurance.find_by(id: new_ins[:id])

    if insurance.update(new_ins)
      @pending_insurance_card.update(status: 'processed')

      notification = {
        alert: "Your insurance info is processed.",
        category: 'ins-ready',
        custom: {
          insId: new_ins[:id]
        }
      }
      MedicationReadyJob.new.delay.perform(insurance.user.device_tokens, notification)

      render json: insurance, status: :created
    else
      render json: insurance.errors, status: :unprocessable_entity
    end
  end

  def image
    idx = params[:idx].to_i
    base64 = @pending_insurance_card.images[idx]
    @image_data = Magick::Image.read_inline(base64)[0].auto_orient
    send_data @image_data.to_blob, :type => 'image/jpeg', disposition: 'inline'
  end

  def show
    render json: @pending_insurance_card
  end

  def destroy
    @pending_insurance_card.destroy

    head :no_content
  end

  private
    def set_pending_insurance_card
      @pending_insurance_card = PendingInsuranceCard.find(params[:id])
    end

    def insurance_card_params
      params[:insurance].permit(
        :id,
        :user_id,
        :company_name,
        :street_address,
        :city,
        :state,
        :zip,
        :plan_code,
        :id_number,
        :group_number,
        :rx_bin,
        :rx_pcn,
        :rx_group,
        :coverage,
        :office_copay,
        :specialist_copay,
        :annual_deductible,
        :deductible_effective_date,
        :member_servies_phone,
        :provider_services_phone,
        :pharmacist_services_phone,
        :nurse_line_phone,
        :website
      )
    end
end
