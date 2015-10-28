require "query_report/engine"
require "query_report/config"

module QueryReport
  def self.configure(&block)
    yield @config ||= QueryReport::Configuration.new
  end

  def self.config
    @config
  end

  configure do |config|
    config.pdf_options = {
        template_class: nil,
        color: '000000',
        font_size: 8,
        table: {
            row: {odd_bg_color: "DDDDDD", even_bg_color: "FFFFFF"},
            header: {bg_color: 'AAAAAA', font_size: 8}
        },
        chart: { height: 160, width: 200 }
    }
    config.date_format     = :default
    config.datetime_format = :default
    config.email_from      = "from@example.com"
    config.allow_email_report  = true
    config.record_table_class  = 'table table-bordered table-striped'
    config.search_button_class = 'btn btn-success'
    # config.search_form_options = {class: 'form-inline'}
  end
end
