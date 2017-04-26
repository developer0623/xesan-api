class WeightsController < ApiController
  include Syncable

  before_action :set_weight, only: [:show, :update, :destroy]

  # POST /weight
  # POST /weight.json
  def create
    @weight = Weight.new(weight_params)
    @weight.user_id = current_user.id unless @weight.user_id

    if @weight.save
      render json: @weight, status: :created
    else
      render json: @weight.errors, status: :unprocessable_entity
    end
  end

  private
    def set_weight
      @weight = Weight.where(id: params[:id], user_id: current_user.id).first
      @weight
    end

    def weight_params
      params.require(:weight).permit(:weight)
    end
end
