# TODO: Probably delete this
class RefillInfosController < ApiController
  # before_action :set_refill_info, only: [:show, :update, :destroy, :image]

  # def update
  #   if @refill_info.update(refill_info_params)
  #     head :no_content
  #   else
  #     render json: @refill_info.errors, status: :unprocessable_entity
  #   end
  # end

  # def index
  #   @rfinfos = RefillInfo.where(medication_id: params[:medication_id])
  #   render json: @rfinfos
  # end

  # def create
  #   @refill_info = RefillInfo.new(params.require(:refill_info).permit!)

  #   @refill_info.active_refill = true

  #   if @refill_info.save
  #     render json: @refill_info, status: :created
  #   else
  #     render json: @refill_info.errors, status: :unprocessable_entity
  #   end
  # end

  # def show
  #   render json: @refill_info
  # end

  # private
  #   def set_refill_info
  #     @refill_info = RefillInfo.find(params[:id])
  #   end

  #   def refill_info_params
  #     params.require(:refill_info).permit(:medication_id, :rx_number, :rx_fill_date, :refill_num, :refill_total, :current_med_count, :days_supply, :discard_date, :refills_expiration)
  #   end
end

