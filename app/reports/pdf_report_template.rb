require 'prawn/table'
require 'prawn/fast_png'

class PdfReportTemplate < QueryReport::ReportPdf

  def render_header
    trackman_logo = "#{Rails.root}/app/assets/images/logo@2x.png"
    pdf.image trackman_logo, :width => 80
    pdf.move_down 30
    report.filters.each do |filter|
      filter.comparators.each do |comparator|
        pdf.text "#{comparator.name} : #{comparator.param_value}" if comparator.param_value.present?
      end
    end
    pdf.move_down 10
  end

  def render_footer
    pdf.move_down 20
    pdf.text "Copyright © 2015 - Trackman", :size => 6, :align => :right
  end

  def render_title
    pdf.text "Report", :size => 10, :style => :bold, :align => :left
  end

  def to_pdf
    render_header
    render_title
    super
    render_footer
    pdf
  end

# ƒ∂ßß∂¬ƒ∆ƒ˚∂¬…ßƒ˚…¬´∑˚®πø´∑®≤∑≥µƒ≥≤µƒ∂ß≥÷ƒß∂µ≤ƒ≥ß∂µƒ……¬∑®≤´…®´∑¬®≤´∑…®¬∑´
#   ƒ¬∂˚ƒß…¬˚
#     ƒ(ƒƒ∂ß¬ƒæ…¬ƒß)
#         ƒß∂¬ƒ˚¬…˚ƒß¬…æ…
#         ´∑…®´∑æ®…
#         ∑´…
#         ®…
#         ´∑…®æ
#         return ∂ƒ…¬ß…ƒ¬∂ß…æƒ¬ß∂

end