class PdfsController < ActionController::Base
  def create
    html = render_to_string(action: "show", layout: false)
    kit = PDFKit.new(html)
    binding.pry
    pdf = kit.to_pdf

    send_data pdf, type: 'application/pdf',
      disposition: "attachment; filename=receipt-#{params.fetch(:submission_id)}.pdf"
  end
end
