module QueryReportEngineFilterHelper
  def query_report_default_text_filter(name, value, options={})
    text_field_tag name, value, options
  end

  def query_report_default_date_filter(name, value, options={})
    text_field_tag name, value, options.merge(class: :datepicker)
  end

  def query_report_default_datetime_filter(name, value, options={})
    text_field_tag name, value, options.merge(class: :datetime)
  end

  def query_report_default_boolean_filter(name, value, options={})
    concat(label_tag options[:placeholder])
    select_tag name, options_for_select([['', ''], ['true', 'true'], ['false', 'false']], value)
  end
end