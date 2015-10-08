class PdfReportVehiclesTemplate < PdfReportTemplate

  def render_title
    pdf.text "Vehicles Report", :size => 10, :style => :bold, :align => :left
  end

end