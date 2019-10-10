class PdfsController < ActionController::Base
  include JwtAuthentication

  respond_to? :json

  def create
    html = render_to_string(action: 'show')
    kit = PDFKit.new(html)
    pdf = kit.to_pdf

    send_data pdf, type: 'application/pdf',
                   disposition: "attachment; filename=receipt-#{params.fetch(:submission_id)}.pdf"
  end
end
