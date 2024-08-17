require 'nokogiri'

class XmlService
  class << self

      def call(file_content)
        process_xml(file_content)
      end

    private

    def process_xml(file_content)
      xml = Nokogiri::XML(file_content)
      namespace = { 'nfe' => 'http://www.portalfiscal.inf.br/nfe' }

      serie = xml.at_xpath('//nfe:infNFe/nfe:ide/nfe:serie', namespace)&.text
      nNF = xml.at_xpath('//nfe:infNFe/nfe:ide/nfe:nNF', namespace)&.text
      dhEmi = xml.at_xpath('//nfe:infNFe/nfe:ide/nfe:dhEmi', namespace)&.text
      emit = xml.at_xpath('//nfe:infNFe/nfe:emit', namespace)
      dest = xml.at_xpath('//nfe:infNFe/nfe:dest', namespace)
      
      if serie.nil? || nNF.nil? || dhEmi.nil? || emit.nil? || dest.nil?
        Rails.logger.error("Missing required fields: serie: #{serie}, nNF: #{nNF}, dhEmi: #{dhEmi}, emit: #{emit}, dest: #{dest}")
        return
      end

      products = xml.xpath('//nfe:det', namespace).map do |product_node|
        {
          xProd: product_node.at_xpath('nfe:prod/nfe:xProd', namespace)&.text,
          NCM: product_node.at_xpath('nfe:prod/nfe:NCM', namespace)&.text,
          CFOP: product_node.at_xpath('nfe:prod/nfe:CFOP', namespace)&.text,
          uCom: product_node.at_xpath('nfe:prod/nfe:uCom', namespace)&.text,
          qCom: product_node.at_xpath('nfe:prod/nfe:qCom', namespace)&.text.to_d,
          vUnCom: product_node.at_xpath('nfe:prod/nfe:vUnCom', namespace)&.text.to_d,
          imposto: {
            ICMS: product_node.at_xpath('nfe:imposto/nfe:ICMS/nfe:ICMS00/nfe:vICMS', namespace)&.text.to_d,
            IPI: product_node.at_xpath('nfe:imposto/nfe:IPI/nfe:IPITrib/nfe:vIPI', namespace)&.text.to_d,
          }
        }
      end

      XmlDocument.create!(
        serie: serie,
        nNF: nNF,
        dhEmi: dhEmi,
        emit: extract_data(emit).to_h.to_json,
        dest: extract_data(dest).to_h.to_json,
        products: products.to_json,
      )
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Failed to save XmlDocument: #{e.message}")
    rescue StandardError => e
      Rails.logger.error("Error processing XML: #{e.message}")
    end
    
    private



    def extract_data(node)
      data = {}
      node.elements.each do |element|
        if element.elements.empty?
          data[element.name.to_sym] = element.text
        else
          data[element.name.to_sym] = extract_data(element)
        end
      end
      data
    end
  end
end
