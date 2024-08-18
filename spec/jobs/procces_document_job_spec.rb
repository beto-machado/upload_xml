RSpec.describe ProcessDocumentJob, type: :job do
  describe '#perform' do
    let(:document) { create(:document, file: fixture_file_upload('spec/fixtures/nota_fiscal.xml', 'application/xml')) }
    let(:file_content) { document.file.download }

    before do
      allow(XmlService).to receive(:call)
    end

    it 'processes the document file' do
      expect(XmlService).to receive(:call).with(file_content, document.id)

      described_class.perform_now(document.id)
    end

    it 'logs an error if the document is not found' do
      allow(Document).to receive(:find).and_raise(ActiveRecord::RecordNotFound)

      expect(Rails.logger).to receive(:error).with(/Failed to process document ##{document.id}/)

      described_class.perform_now(document.id)
    end

    it 'logs an error if an exception occurs' do
      allow(XmlService).to receive(:call).and_raise(StandardError, 'Some error')

      expect(Rails.logger).to receive(:error).with(/Failed to process document ##{document.id}: Some error/)

      described_class.perform_now(document.id)
    end
  end
end
