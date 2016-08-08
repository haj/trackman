class AlarmsController < ApplicationController
  # Include module / class
  include Batchable

  # Initialize something from GEM
  load_and_authorize_resource :except => [:create]  

  # Callback controller
  before_action :set_alarm, only: [:edit, :update, :destroy]

  # GET /alarms || alarms_path
  # List all alarms available in HTML Format 
  def index
    @alarms = Alarm.all

    respond_with(@alarms)
  end

  # GET /alarms/1
  # GET /alarms/1.json
  def show
    @alarm = Alarm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js   # show.js.erb
      format.json { render json: @alarm }
    end    
  end

  # GET /alarms/new
  def new
    @alarm = Alarm.new

    respond_with(@alarm)
  end

  # GET /alarms/1/edit
  def edit
    respond_with(@alarm)
  end

  # POST /alarms
  # POST /alarms.json
  def create
    @alarm = Alarm.new(alarm_params)
    if @alarm.save
      respond_with(@alarm, location: @alarm, notice: 'Alarm was successfully created.')
    else
      respond_with(@alarm)
    end
  end

  # PATCH/PUT /alarms/1
  # PATCH/PUT /alarms/1.json
  def update
    if @alarm.update(alarm_params)
      respond_with(@alarm, location: @alarm, notice: 'Alarm was successfully updated.')
    else
      respond_with(@alarm)
    end
  end
  
  # Delete /alarms/:id || alarm_path(:id)
  # Delete specific alarm
  def destroy
    @alarm.destroy

    respond_with(@alarm, location: alarms_path, notice: 'Alarm was successfully deleted.')
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_alarm
    @alarm = Alarm.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def alarm_params
    rule_params = Rule.all.map(&:params).flatten.map{ |e| e.name.to_sym }.uniq rescue []

    params.require(:alarm).permit(
      :name, 
      alarm_rules_attributes: [
        :id, :rule_id, :_destroy, :conjunction, { params: [rule_params] }
      ]
    )
  end
end
