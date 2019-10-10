class PdfsController < ActionController::Base
  include JwtAuthentication

  respond_to? :json

  def create
    payload = json_hash
    @submission_id = payload.fetch(:submission_id)
    @heading = payload.fetch(:pdf_heading)
    @sub_heading = payload.fetch(:pdf_subheading)
    @sections = payload.fetch(:sections)

    html = render_to_string(action: 'show')
    kit = PDFKit.new(html)
    pdf = kit.to_pdf

    send_data(pdf, type: 'application/pdf', disposition: "attachment; filename=receipt-#{payload.fetch(:submission_id)}.pdf")
  end

  private

  def json_hash
    JSON.parse(request.raw_post, symbolize_names: true)
  end
end
