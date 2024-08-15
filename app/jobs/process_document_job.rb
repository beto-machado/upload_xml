require 'nokogiri'

class ProcessDocumentJob < ApplicationJob
  queue_as :default

  def perform(xml_file_id)
    xml_file = Document.find(xml_file_id)
    file_content = xml_file.file.download
    process_xml(file_content)
  end

  private

  def process_xml(file_content)
    xml = Nokogiri::XML(file_content)

    # Extração dos dados do XML
    document_data = {
      serie: xml.at_xpath('//nfeProc/NFe/infNFe/ide/serie').text,
      nNF: xml.at_xpath('//nfeProc/NFe/infNFe/ide/nNF').text,
      dhEmi: xml.at_xpath('//nfeProc/NFe/infNFe/ide/dhEmi').text,
      emit: xml.at_xpath('//nfeProc/NFe/infNFe/emit').to_h.to_json,
      dest: xml.at_xpath('//nfeProc/NFe/infNFe/dest').to_h.to_json
    }

    # Extração dos produtos
    products = xml.xpath('//nfeProc/NFe/infNFe/det').map do |product_node|
      {
        xProd: product_node.at_xpath('prod/xProd').text,
        NCM: product_node.at_xpath('prod/NCM').text,
        CFOP: product_node.at_xpath('prod/CFOP').text,
        uCom: product_node.at_xpath('prod/uCom').text,
        qCom: product_node.at_xpath('prod/qCom').text.to_d,
        vUnCom: product_node.at_xpath('prod/vUnCom').text.to_d
      }
    end

    # Extração dos impostos
    tax_node = xml.at_xpath('//nfeProc/NFe/infNFe/total/ICMStot')
    tax = {
      vICMS: tax_node.at_xpath('vICMS').text.to_d,
      vIPI: tax_node.at_xpath('vIPI').text.to_d,
      vPIS: tax_node.at_xpath('vPIS').text.to_d,
      vCOFINS: tax_node.at_xpath('vCOFINS').text.to_d
    }

    # Salvar os dados no banco
    Document.create!(
      serie: document_data[:serie],
      nNF: document_data[:nNF],
      dhEmi: document_data[:dhEmi],
      emit: document_data[:emit],
      dest: document_data[:dest],
      products: products.to_json,
      tax: tax.to_json
    )
  end
end
