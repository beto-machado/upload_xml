class ProcessDocumentJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    xml_file = Document.find(document_id)
    file_content = xml_file.file.download
    XmlService.call(file_content)
  rescue StandardError => e
    Rails.logger.error("Failed to process document ##{document_id}: #{e.message}")
  end
end
