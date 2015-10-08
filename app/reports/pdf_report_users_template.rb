class PdfReportUsersTemplate < PdfReportTemplate

  def render_title
    pdf.text "Users Report", :size => 10, :style => :bold, :align => :left
  end

end