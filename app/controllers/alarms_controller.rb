class AlarmsController < ApplicationController
  before_action :set_alarm, only: [:edit, :update, :destroy]

 load_and_authorize_resource :except => [:create]

  # GET /alarms
  # GET /alarms.json
  

  # GET /alarms/1
  # GET /alarms/1.json
  def show
    @alarm = Alarm.find(params[:id])
    @rules = @alarm.rules

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

    hash = { name: alarm_params['name'] }

    @alarm = Alarm.new(hash)

    if @alarm.save
      logger.debug "[ALARMS] alarm saved"
      rules = alarm_params['rules_attributes']

      rules.each_with_index do |(key,value),index| 
        if value['_destroy'] != "1"
          # fetch current rule
          rule = Rule.find(value['id'].to_i) 
          @alarm.rules << rule
          # get the alarm -> rule record
          alarm_rule = AlarmRule.where(alarm_id: @alarm.id, rule_id: rule.id).first
          # update the params for current alarm -> rule
          alarm_rule.update_attribute(:params, value['params'])
          # update the conjunction
          if index != 0 
            alarm_rule.update_attribute(:conjunction, value['conjunction']['value'].to_s)
          end
        end
      end

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
      format.html {render :layout => "index_template"}
    end
  end
 
  def batch_destroy
    alarm_ids = params[:alarm_ids]
    alarm_ids.each do |alarm_id|
      @alarm = Alarm.find(alarm_id)
      @alarm.destroy
    end
    redirect_to alarms_path
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
      params.require(:alarm).permit!
    end
end
