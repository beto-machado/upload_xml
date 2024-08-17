class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @xml_documents = XmlDocument.all
  end
  def show
    @xml_document = XmlDocument.find(params[:id])
  end
end
