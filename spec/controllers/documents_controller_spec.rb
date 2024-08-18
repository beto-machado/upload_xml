RSpec.describe DocumentsController, type: :controller do
  let(:user) { create(:user) }
  let(:document) { build(:document) }

  before do
    sign_in user
  end

  describe 'GET #new' do
    it 'assigns a new document to document' do
      get :new
      expect(assigns(:document)).to be_a_new(Document)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:file) { fixture_file_upload('spec/fixtures/nota_fiscal.xml', 'application/xml') }

      it 'creates a new document' do
        expect {
          post :create, params: { document: { file: file } }
        }.to change(Document, :count).by(1)
      end

      it 'enqueues a ProcessDocumentJob' do
        expect(ProcessDocumentJob).to receive(:perform_now).and_call_original
        post :create, params: { document: { file: file } }
      end

      it 'redirects to the document report path if XML document is present' do
        post :create, params: { document: { file: file } }
        xml_document = Document.last.xml_document
        expect(response).to redirect_to(document_report_path(Document.last.id, xml_document.id))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new document' do
        expect {
          post :create, params: { document: { file: nil } }
        }.not_to change(Document, :count)
      end

      it 'renders the new template if document is invalid' do
        post :create, params: { document: { file: nil } }
        expect(response).to render_template(:new)
      end
    end
  end
end
