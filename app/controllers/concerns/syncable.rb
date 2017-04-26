module Syncable
  extend ActiveSupport::Concern

  def time_var
    "created_at"
  end

  def index
    where = %Q{user_id = :user_id}
    where_params = {
      user_id: current_user.id
    }

    if params[:since]
      where += %Q{ AND #{time_var} > :since}
      where_params[:since] = params[:since]
    end
    render json: model_class.where(where, where_params)
  end

  def batch_create
    model_class.transaction do
      model_class.import batch_params
    end
    render json: batch_params, status: :created
  rescue Exception => e
    p e
    render json: e, status: 400
  end

  def batch_update
    user_id = current_user.id

    results = []
    model_class.transaction do
      batch_update_params.each do |m|
        model = model_class.where(id: m[:id], user_id: user_id).first
        model.update(m)
        results.push(model)
      end
    end
    render json: results, status: :ok
  rescue ActionController::ParameterMissing => e
    render json: e, status: 400
  rescue Exception => e
    p e
    render json: e, status: :unprocessable_entity
  end

  def batch_delete
    user_id = current_user.id
    model_class.transaction do
      model_class.where(%Q{id IN (#{batch_delete_params.join(',')})}).each do |model|
        model.destroy
      end
    end
    head :no_content
  rescue ActionController::ParameterMissing => e
    render json: e, status: 400
  rescue Exception => e
    render json: e, status: :unprocessable_entity
  end

  def model_class
    controller_name.classify.constantize
  end

  def batch_params
    @_batch_params ||= begin
      params.permit!().require(controller_name.pluralize.to_sym).map do |o|
        o[:user_id] = current_user.id
        model_class.new(o)
      end
    end
  end

  def batch_update_params
    @_batch_update_params ||= begin
      params.permit!().require(controller_name.pluralize.to_sym).map do |o|
        o[:user_id] = current_user.id
        o
      end
    end
  end

  def batch_delete_params
    @_batch_delete_params ||= begin
      params.permit!().require(:ids)
    end
  end
end
