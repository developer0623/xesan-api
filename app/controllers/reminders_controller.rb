class RemindersController < ApiController
  before_action :set_reminder, only: [:show, :update, :destroy, :image]

  def get_medication_reminders
    render json: Reminder.where(medication_id: params[:medication_id])
  end

  def index
    @reminders = Reminder.joins(:medication).includes(:medication).where(%Q{"reminders"."#{params[:day].downcase}" = TRUE})#, :include => :medication
    render json: @reminders
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.user_id = current_user.id

    if @reminder.save
      render json: @reminder, status: :created
    else
      render json: @reminder.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @reminder
  end

  private
    def set_reminder
      @reminder = Reminder.find(params[:id])
    end

    def reminder_params
      params.require(:reminder).permit(:medication_id, :hour, :minute,
        :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday,
        :start_date, :end_date, :deleted)
    end
end

