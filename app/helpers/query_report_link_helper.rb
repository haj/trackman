module QueryReportLinkHelper
  def link_to_download_report_pdf
    link_to t('views.links.pdf'), export_report_url_with_format('pdf'), :target => "_blank", class: 'btn btn-danger btn-smalll'
  end

  def link_to_download_report_csv
    link_to t('views.links.csv'), export_report_url_with_format('csv'), :target => "_blank", class: 'btn btn-primary btn-smalll'
  end

  def link_to_email_query_report(target_dom_id)
    link_to t('views.labels.email'), 'javascript:void(0)', class: 'btn btn-smalll btn-white', :onclick => "QueryReportEmail.openEmailModal('#{target_dom_id}');" if QueryReport.config.allow_email_report
  end
end