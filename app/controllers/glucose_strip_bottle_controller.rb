class GlucoseStripBottleController < ApiController
  # unnecessary, but useful for debugging
  def index
    render json: current_user.glucose_strip_bottles, status: 200
  end

  # POST /glucose_strip_bottle
  # POST /glucose_strip_bottle.json
  def create
    GlucoseStripBottle.where(user_id: current_user.id)
      .update_all(current: false)

    # TODO: lot_number / expired ?
    @gsb = GlucoseStripBottle.new(strip_count: 50, current: true, opened: Time.now)
    current_user.glucose_strip_bottles << @gsb

    if @gsb.save
      render json: @gsb, status: :created
    else
      render json: @gsb.errors, status: :unprocessable_entity
    end
  end

  def decrement_strip_count
    @gsb = current_user.glucose_strip_bottle
    if (@gsb)
      strip_count = @gsb.strip_count
      strip_count = strip_count - 1

      if (strip_count >= 0)
        @gsb.strip_count = strip_count

        if @gsb.save
          render json: @gsb, status: 200
        else
          render json: @gsb.errors, status: :unprocessable_entity
        end
      else
        render json: { errors: ['empty glucose strip bottle'] }, status: :bad_request
      end
    else
      render json: { errors: ['no glucose strip bottle'] }, status: :bad_request
    end
  end

  def set_strip_count
    count = params[:count]
    @gsb = current_user.glucose_strip_bottle
    if (@gsb)
      @gsb.strip_count = count

      if @gsb.save
        render json: @gsb, status: 200
      else
        render json: @gsb.errors, status: :unprocessable_entity
      end
    else
      render json: { errors: ['no glucose strip bottle'] }, status: :bad_request
    end
  end
end
