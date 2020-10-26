class PdfsController < ActionController::Base
  include JwtAuthentication

  def create
    submission_id = submission_params.fetch(:submission_id)

    @heading = submission_params.fetch(:pdf_heading, nil)
    @sub_heading = submission_params.fetch(:pdf_subheading, nil)
    @sections = submission_params.fetch(:sections)

    html = render_to_string(action: 'show', formats: [:html])
    kit = PDFKit.new(html, footer_left: left_footer(submission_id))
    pdf = kit.to_pdf

    send_data(pdf, type: 'application/pdf', disposition: "attachment; filename=receipt-#{submission_id}.pdf")
  end

  private

  def left_footer(submission_id)
    "#{submission_id} / #{Time.now.strftime('%a, %d %b %Y %H:%M:%S')} #{Time.zone.name}"
  end

  def submission_params
    @submission_params ||= begin
      params.permit!
      params.to_hash.deep_symbolize_keys
    end
  end
end
