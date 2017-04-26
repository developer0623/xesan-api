class GlucosesController < ApiController
  include Syncable

  before_action :set_glucose, only: [:show, :destroy]

  # POST /glucose
  # POST /glucose.json
  def create
    @glucose = Glucose.new(glucose_params)
    @glucose.user = current_user unless @glucose.user_id

    if @glucose.save
      render json: @glucose, status: :created
    else
      render json: @glucose.errors, status: :unprocessable_entity
    end
  end

  # DELETE /glucoses/1
  # DELETE /glucoses/1.json
  def destroy
    @glucose.destroy

    head :no_content
  end

  private
    def set_glucose
      @glucose = Glucose.where(id: params[:id], user_id: current_user.id).first
      @glucose
    end

    def glucose_params
      params.require(:glucose).permit(:value, :notes, :created_at, :is_control, :activities => [])
    end
end
