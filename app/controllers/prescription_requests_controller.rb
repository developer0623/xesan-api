class PrescriptionRequestsController < ApiController
  include Syncable

  def index
    provider_id = ProviderUser.find_by(id: current_provider_user.id).provider_id;
    prescription_req = PrescriptionRequest.where(%Q{provider_id=#{provider_id} AND status IN ('new', 'processing')});
    render json: prescription_req
  end

  def create
    @rx_req = PrescriptionRequest.new(prescription_request_params)
    @rx_req.user = current_user unless @rx_req.user_id

    if @rx_req.save
      render json: @rx_req, status: :created
    else
      render json: @rx_req.errors, status: :unprocessable_entity
    end
  end

  def update

    prescription_req = PrescriptionRequest.find_by(id: params[:id])
    prescription_req.status = params[:status]
    prescription_req.note = params[:note]

    if prescription_req.save
      notification = {
        alert: "Your prescription request status is changed to " + params[:status],
        category: 'rx-refill-status-change',
        custom: {
          prescriptionRequestId: prescription_req.id,
          status: prescription_req.status,
          note: prescription_req.note
        }
      }
      MedicationReadyJob.new.delay.perform(prescription_req.user.device_tokens, notification)
      render json: prescription_req, status: 200
    else
      render json: prescription_req, status: 500
    end
  end

  private
    def prescription_request_params
      params.require(:prescription_request).permit(:medication_id, :user_id, :provider_id, :status, :note, :end_date, :created_at, :updated_at)
    end

end
