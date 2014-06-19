class AlarmMailer < ActionMailer::Base
  default from: "from@example.com"

  def alarm_email(user, car, alarm)
    @user = user
    @alarm = alarm
    @car = car
    @url  = 'http://admin.trackman.dev'
    mail(to: @user.email, subject: 'New Alarm')
  end
end
