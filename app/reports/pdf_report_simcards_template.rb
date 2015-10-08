class PdfReportSimcardsTemplate < PdfReportTemplate

  def render_title
    pdf.text "Simcards Report", :size => 10, :style => :bold, :align => :left
  end

end