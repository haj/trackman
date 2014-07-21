class AlarmsController < ApplicationController
  before_action :set_alarm, only: [ :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /alarms
  # GET /alarms.json
  def index
    @alarms = Alarm.all
  end

  # GET /alarms/1
  # GET /alarms/1.json
  def show
    @alarm = Alarm.find(params[:id])
    @rules = @alarm.rules
    
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
     
    # render text: params
    # return

    hash = {name: alarm_params['name']}
    @alarm = Alarm.new(hash)

    if @alarm.save

      rules = alarm_params['rules_attributes']

      rules.each_with_index do |(key,value),index| 
        if value['_destroy'] != "1"
          # fetch current rule
          rule = Rule.find(value['id'].to_i) 
          @alarm.rules << rule
          # get the alarm -> rule record
          alarm_rule = AlarmRule.where(alarm_id: @alarm.id, rule_id: rule.id).first
          # update the params for current alarm -> rule
          alarm_rule.update_attribute(:params, value['params'].to_s)
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

  # DELETE /alarms/1
  # DELETE /alarms/1.json
  def destroy
    @alarm.destroy
    respond_to do |format|
      format.html { redirect_to alarms_url, notice: 'Alarm was successfully destroyed.' }
      format.json { head :no_content }
    end
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
