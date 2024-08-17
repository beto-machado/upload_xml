class ProcessDocumentJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    document = Document.find(document_id)
    file_content = document.file.download
    XmlService.call(file_content, document.id)
  rescue StandardError => e
    Rails.logger.error("Failed to process document ##{document_id}: #{e.message}")
  end
end
