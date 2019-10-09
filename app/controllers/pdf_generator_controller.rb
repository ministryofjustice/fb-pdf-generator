class PdfGeneratorController < ApplicationController
  def create
    render json: { placeholder: true }, status: 200
  end
end
