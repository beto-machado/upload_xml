class ReportsController < ApplicationController
  def show
    @xml_document = XmlDocument.find(params[:id])
  end
end
