module QueryReport
  class ReportPdf
    attr_reader :pdf, :options, :report

    def initialize(report)
      @report = report
      @options = QueryReport.config.pdf_options
      @pdf = Prawn::Document.new
    end

    #render the header from the template class
    def render_header
      template.try(:render_header)
    end

    def render_footer
      template.try(:render_footer)
    end

    def to_pdf
      render_charts_with report
      render_table_with report
      pdf
    end

    private
    def render_charts_with(report)
      return if report.charts.empty? #or !report.chart_on_pdf?
      num_of_column = 2
      height = (pdf.bounds.width/num_of_column - 50) * (report.charts.size.to_f/num_of_column).ceil
      pdf.column_box([0, pdf.cursor], :columns => num_of_column, :width => pdf.bounds.width, :height => height) do
        report.charts.each do |chart|
          render_chart(chart)
        end
      end
    end

    def render_chart(chart)
      if chart.respond_to?(:to_blob)
        blob = chart.to_blob
        data = StringIO.new(blob)
        #pdf.pad_top(10) do
        pdf.image(data, :width => pdf.bounds.width)
        #end
      end
    end

    def table_header_for(table_items)
      table_items.first.keys
    end

    def humanized_table_header
      report_columns.collect { |h| fix_content h.humanize }
    end

    def alignment_hash
      @alignment_hash ||= report.columns.inject({}) do |col_hash, col|
        col_hash[col.humanize] = col.align if col.align; col_hash
      end
    end

    def table_content_for(report)
      table_items = report.all_records_to_render

      items = table_items.map do |item|
        item_values = []

        report_columns.collect(&:humanize).each do |column|
          item_values << prepare_content(column, item) if item.has_key? column
        end
        item_values
      end

      if report.has_total?
        items = items << report.column_total_with_colspan.collect do |total|
          total[:content] = fix_content(total[:content])
          total
        end
      end
      items
    end

    def prepare_content(column, item)
      content = fix_content(item[column])
      if alignment_hash[column]
        if content.kind_of? Hash
          content[:align] = alignment_hash[column]
        else
          content = {content: fix_content(content), align: alignment_hash[column]}
        end
      end
      content
    end

    def render_table_with(report)
      items = [humanized_table_header]
      items += table_content_for(report)
      render_table(items)
    end

    def render_table(items)
      header_bg_color = options[:table][:header][:bg_color]
      alternate_row_bg_color = [options[:table][:row][:odd_bg_color], options[:table][:row][:even_bg_color]]
      font_size = options[:font_size]
      header_font_size = options[:table][:header][:font_size]
      pdf.move_down 10

      table_options = {:row_colors => alternate_row_bg_color, :header => false, :cell_style => {:inline_format => true, :size => font_size}}

      report.columns.each_with_index do |report_column, index|
        width = report_column.pdf_options[:width]
        if width
          table_options[:column_widths] ||= {}
          table_options[:column_widths].merge! index => width
        end
      end

      pdf.table(items, table_options) do
        row(0).style(:font_style => :bold, :background_color => header_bg_color, :size => header_font_size)
      end
    end

    def fix_content(content)
      if content.kind_of?(Hash)
        content[:content] = content[:content].to_s
        content
      else
        content.to_s
      end
    end

    private
    def report_columns
      report.columns.select { |c| !c.only_on_web? }
    end

    def template
      if options[:template_class]
        @template ||= options[:template_class].to_s.constantize.new(report, pdf)
        return @template
      end
      nil
    end
  end
end