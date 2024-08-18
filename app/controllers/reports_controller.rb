class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_xml_document, only: [:show, :export_to_csv]

  def index
    @q = XmlDocument.ransack(params[:q])
    @xml_documents = @q.result.page(params[:page]).per(10)
  end
  def show; end

  def export_to_csv
    send_data(ExportCsvService.call(@xml_document), filename: "relatorio_#{@xml_document.nNF}.csv")
  end

  private

  def set_xml_document
    @xml_document = XmlDocument.find(params[:id])
  end
end
