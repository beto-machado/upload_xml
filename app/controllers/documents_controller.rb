class DocumentsController < ApplicationController

  # before_action :authenticate_user!
  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      ProcessDocumentJob.perform_later(@document.id)
      redirect_to report_path(@document.id), notice: 'Arquivo enviado e processamento iniciado.'
    else
      render :new
    end
  end

  private

  def document_params
    params.require(:document).permit(:file)
  end
end
