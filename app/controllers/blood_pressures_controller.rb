class BloodPressuresController < ApiController
  include Syncable

  before_action :set_blood_pressure, only: [:show, :update, :destroy]

  # POST /blood_pressure
  # POST /blood_pressure.json
  def create
    @blood_pressure = BloodPressure.new(blood_pressure_params)
    @blood_pressure.user_id = current_user.id unless @blood_pressure.user_id

    if @blood_pressure.save
      render json: @blood_pressure, status: :created
    else
      render json: @blood_pressure.errors, status: :unprocessable_entity
    end
  end

  private
    def set_blood_pressure
      @blood_pressure = BloodPressure.where(id: params[:id], user_id: current_user.id).first
      @blood_pressure
    end

    def blood_pressure_params
      params.require(:blood_pressure).permit(:systolic, :diastolic)
    end
end
