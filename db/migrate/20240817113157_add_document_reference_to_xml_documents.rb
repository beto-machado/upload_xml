class AddDocumentReferenceToXmlDocuments < ActiveRecord::Migration[7.1]
  def change
    add_reference :xml_documents, :document, null: false, foreign_key: true
  end
end
