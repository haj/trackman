class PdfReportDevicesTemplate < PdfReportTemplate

  def render_title
    pdf.text "Devices Report", :size => 10, :style => :bold, :align => :left
  end

end