require 'query_report/helper'

module QueryReportHelper
  QueryReport.config.search_button_class = 'btn btn-success'
  QueryReport.config.pdf_options = {
    template_class: nil,
    color: '000000',
    font_size: 8,
    table: {
        row: {odd_bg_color: "ffffff", even_bg_color: "ffffff"},
        header: {bg_color: 'CCCCCC', font_size: 8}
    },
    chart: { height: 160, width: 200 }
  }
  # QueryReport.config.record_table_class  = 'table table-bordered table-striped'
  # QueryReport.config.search_form_options = {class: 'form-inline'}
  QueryReport.config.email_from = "boulaidzac#@gmail.com"

  include QueryReport::Helper
end