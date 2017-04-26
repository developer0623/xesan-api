class PulseOxygensController < ApiController
  include Syncable

  before_action :set_pulse_oxygen, only: [:show, :update, :destroy]

  # POST /pulse_oxygen
  # POST /pulse_oxygen.json
  def create
    @pulse_oxygen = PulseOxygen.new(pulse_oxygen_params)
    @pulse_oxygen.user_id = current_user.id unless @pulse_oxygen.user_id

    if @pulse_oxygen.save
      render json: @pulse_oxygen, status: :created
    else
      render json: @pulse_oxygen.errors, status: :unprocessable_entity
    end
  end

  private
    def set_pulse_oxygen
      @pulse_oxygen = PulseOxygen.where(id: params[:id], user_id: current_user.id).first
      @pulse_oxygen
    end

    def pulse_oxygen_params
      params.require(:pulse_oxygen).permit(:pulse_oxygen)
    end
end
