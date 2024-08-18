RSpec.describe ReportsController, type: :controller do
  let(:user) { create(:user) }
  let(:document) { create(:document)}
  let(:xml_document) { create(:xml_document, document_id: document.id) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'assigns @q and xml_documents' do
      get :index
      expect(assigns(:q)).to be_a(Ransack::Search)
      expect(assigns(:xml_documents)).to include(xml_document)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested xml_document to xml_document' do
      get :show, params: { document_id: document.id, id: xml_document.id }
      expect(assigns(:xml_document)).to eq(xml_document)
    end

    it 'renders the show template' do
      get :show, params: { document_id: document.id, id: xml_document.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #export_to_csv' do
    it 'sends a CSV file' do
      expect(ExportCsvService).to receive(:call).with(xml_document).and_return("csv_content")
      get :export_to_csv, params: { id: xml_document.id }
      expect(response.headers['Content-Disposition']).to include("filename=\"relatorio_#{xml_document.nNF}.csv\"")
      expect(response.body).to eq "csv_content"
    end
  end
end
