class TemperaturesController < ApiController
  include Syncable

  before_action :set_temperature, only: [:show, :update, :destroy]

  # POST /temperature
  # POST /temperature.json
  def create
    @temperature = Temperature.new(temperature_params)
    @temperature.user_id = current_user.id unless @temperature.user_id

    if @temperature.save
      render json: @temperature, status: :created
    else
      render json: @temperature.errors, status: :unprocessable_entity
    end
  end

  private
    def set_temperature
      @temperature = Temperature.where(id: params[:id], user_id: current_user.id).first
      @temperature
    end

    def temperature_params
      params.require(:temperature).permit(:temperature)
    end
end
