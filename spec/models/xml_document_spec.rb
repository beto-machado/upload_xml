RSpec.describe XmlDocument, type: :model do
  describe 'associations' do
    it { should belong_to(:document) }
  end

  describe 'validations' do
    it 'validates uniqueness of document_id' do
      document = create(:document)
      create(:xml_document, document: document)
      should validate_uniqueness_of(:document_id)
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the correct ransackable attributes' do
      expected_attributes = ["created_at", "dest", "dhEmi", "document_id", "emit", "nNF", "products", "serie", "tax", "updated_at"]
      expect(XmlDocument.ransackable_attributes).to match_array(expected_attributes)
    end
  end
end
