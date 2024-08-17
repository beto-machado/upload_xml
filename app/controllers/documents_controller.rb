class DocumentsController < ApplicationController
  before_action :authenticate_user!
  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      ProcessDocumentJob.perform_now(@document.id)
      xml_document = @document.xml_document
      if xml_document.present?
        redirect_to document_report_path(@document.id, xml_document.id)
      else
        render :new
      end
    else
      render :new
    end
  end

  private

  def document_params
    params.require(:document).permit(:file)
  end
end
