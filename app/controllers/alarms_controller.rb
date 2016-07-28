class AlarmsController < ApplicationController
  include Batchable

  load_and_authorize_resource :except => [:create]
  
  before_action :set_alarm, only: [:edit, :update, :destroy]

  # GET /alarms/1
  # GET /alarms/1.json
  def show
    @alarm = Alarm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js # show.js.erb
      format.json { render json: @alarm }
    end    
  end

  # GET /alarms/new
  def new
    @alarm = Alarm.new
  end

  # GET /alarms/1/edit
  def edit
  end

  # POST /alarms
  # POST /alarms.json
  def create
    @alarm = Alarm.new(alarm_params)
    if @alarm.save
      redirect_to @alarm, notice: 'Alarm was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /alarms/1
  # PATCH/PUT /alarms/1.json
  def update
    respond_to do |format|
      if @alarm.update(alarm_params)
        format.html { redirect_to @alarm, notice: 'Alarm was successfully updated.' }
        format.json { render :show, status: :ok, location: @alarm }
      else
        format.html { render :edit }
        format.json { render json: @alarm.errors, status: :unprocessable_entity }
      end
    end
  end
 
  def index
    @alarms = Alarm.all
    respond_to do |format|
      format.html
    end
  end
 
  def destroy
    @alarm.destroy
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
