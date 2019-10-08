class PdfGeneratorController < ActionController::API
  def create
    html = '<html><head></head><body>hello</body></html>'
    kit = PDFKit.new(html)
    pdf = kit.to_pdf

    send_data pdf, type: 'application/pdf',
      disposition: "attachment; filename=receipt-#{params.fetch(:submission_id)}.pdf"
  end
end
