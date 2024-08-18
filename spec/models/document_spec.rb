RSpec.describe Document, type: :model do

  describe 'associations' do
    it { should have_one(:xml_document) }
    it { should have_one_attached(:file) }
  end

  describe 'validations' do
    context 'when file is present' do
      it 'is valid' do
        document = Document.new(file: fixture_file_upload('spec/fixtures/nota_fiscal.xml', 'application/xml'))
        expect(document).to be_valid
      end
    end

    context 'when file is not present' do
      it 'is not valid and adds a file presence error' do
        document = Document.new(file: nil)
        expect(document).not_to be_valid
        expect(document.errors[:file]).to include("can't be blank")
      end
    end
  end
end
