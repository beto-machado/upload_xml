class DocumentsController < ApplicationController
  # before_action :authenticate_user!
  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      ProcessXmlJob.perform_later(@document.id)
      redirect_to @document, notice: 'Arquivo enviado e processamento iniciado.'
    else
      render :new
    end
  end

  private

  def document_params
    params.require(:document).permit(:file)
  end
end
