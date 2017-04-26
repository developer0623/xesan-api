class MedicationsController < ApiController
  include Syncable

  before_action :set_medication, only: [:show, :update, :destroy]

  def time_var
    "updated_at"
  end

  # GET /medication/1
  # GET /medication/1.json
  def show
    render json: @medication
  end

  # POST /medication
  # POST /medication.json
  def create
    @medication = Medication.new(medication_params)
    @medication.user = current_user unless @medication.user_id

    if @medication.save
      render json: @medication, status: :created
    else
      render json: @medication.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /medication/1
  # PATCH/PUT /medication/1.json
  def update
    if @medication.update(medication_params)
      head :no_content
    else
      render json: @medication.errors, status: :unprocessable_entity
    end
  end

  # DELETE /medication/1
  # DELETE /medication/1.json
  def destroy
    @medication.destroy

    head :no_content
  end

  def by_refill
    rx_num = params[:rx_num]
    user_id = params[:user_id]

    refill = RefillInfo.joins(:medication).where(refill_infos: {rx_number: rx_num, active_refill: true}, medications: {user_id: user_id}).first

    if (refill && refill.medication)
      render json: refill.medication
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def load_info
    # folks claimed ActiveRecord is the biggest source
    # for rails performance problems.
    # so try not to use association for now.
    # ORMs are rarely good at those things anyway.
    package_info_q = NdcPackage.where("fda_native_code = ? OR ndc_package_code = ?", params[:ndc], params[:ndc])
    if (package_info_q.exists?)
      package_info = package_info_q
                      .select("ndc_product_id, description")
                      .first
      product = NdcProduct.where(id: package_info[:ndc_product_id])
                      .select("id, proprietary_name, proprietary_name_suffix, dosage_form_name, route_name, substance_name, active_numerator_strength, active_ingred_unit, product_type_name")
                      .first
                      .as_json
      product[:description] = package_info[:description]
      product[:ndc] = params[:ndc]
      render json: product, status: 200
    else
      #status not found
      render json: {error_message: "No NDC record found.", ndc: params[:ndc]}, status: 404
    end
  end

  def verify_ndc
    if (NdcPackage.where("fda_native_code = ? OR ndc_package_code = ?", params[:ndc], params[:ndc]).exists?)
      render json: {ndc: params[:ndc], found: true}, status: 200
    else
      render json: {error_message: "No NDC record found.", ndc: params[:ndc]}, status: 404
    end
  end

  private
    def set_medication
      @medication = Medication.where(id: params[:id], user_id: current_user.id).first
      @medication
    end

    def medication_params
      params.require(:medication).permit(:name, :dose, :frequency, :strength, :refill, :refills_remaining,
        :discard_date, :reason_for_taking, :prescriber_id, :pharmacy_id, :form, :count,
        :route, :category, :description, :instructions, :ndc, :user_id, :created_at, :updated_at,
        reminders_attributes: [
          :id, :guid, :hour, :minute, :start_date, :end_date, :deleted, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :user_id,
          med_entries_attributes: [ :id, :taken, :scheduled_time, :actual_time, :user_id, :medication_id ]
        ],
        refills_attributes: [ :id, :rx_number, :rx_fill_date, :refill_num, :refill_total, :current_med_count, :days_supply, :discard_date, :refills_expiration, :created_at, :active_refill ])
    end
end
