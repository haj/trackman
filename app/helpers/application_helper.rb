module ApplicationHelper
  def without_tmz time
    time.to_s(:db)
  end

  def dates_in_range start_date, end_date
    @array_dates = []

    start_date.upto(end_date).each do |date|
      @array_dates << date
    end

    @array_dates
  end

  def notifications_count(user)
    alarm_notifications = user.try(:company).try(:alarm_notifications)
    if alarm_notifications
      notifications = alarm_notifications.where(archived: false).try(:count)
      if notifications.nil?
        0
      else
        notifications
      end
    else
      0
    end
  end

  def notification_title(notification)
    notification.subject.split(":")[0].strip
  end

  def notification_desc(notification)
    notification.subject.split(":")[1].strip
  end

  def gravatar(current_user)
    gravatar_image_url(current_user.email.gsub('spam', 'mdeering'))
  end
end
