require "csv"

class ExportCsvService
  class << self
    def call(xml_document)
      generate_csv_data(xml_document)
    end

    private
      def generate_csv_data(xml_document)
        CSV.generate(headers: true) do |csv|
          csv << ['RELATÓRIO DO DOCUMENTO FISCAL']
          csv << ['']

          csv << ['Número de Série', xml_document.serie]
          csv << ['Número da Nota Fiscal', xml_document.nNF]
          csv << ['Data e Hora de Emissão', xml_document.dhEmi.strftime('%d/%m/%Y %H:%M:%S')]
          csv << ['']
    
          emit = JSON.parse(xml_document.emit)
          csv << ['Emitente', emit["xNome"]]
          csv << ['CNPJ', emit["CNPJ"]]
          csv << ['Telefone', emit["fone"]]
          csv << ['Endereço', "#{emit["enderEmit"]["xLgr"]}, #{emit["enderEmit"]["nro"]}, #{emit["enderEmit"]["xBairro"]}"]
          csv << ['Cidade', emit["enderEmit"]["xMun"]]
          csv << ['Estado', emit["enderEmit"]["UF"]]
          csv << ['CEP', emit["enderEmit"]["CEP"]]
          csv << ['País', emit["enderEmit"]["xPais"]]
          csv << ['Inscrição Estadual', emit["IE"]]
          csv << ['']
    
          dest = JSON.parse(xml_document.dest)
          csv << ['Destinatário', dest["xNome"]]
          csv << ['CNPJ', dest["CNPJ"]]
          csv << ['Endereço', "#{dest["enderDest"]["xLgr"]}, #{dest["enderDest"]["xBairro"]}"]
          csv << ['Cidade', dest["enderDest"]["xMun"]]
          csv << ['Estado', dest["enderDest"]["UF"]]
          csv << ['CEP', dest["enderDest"]["CEP"]]
          csv << ['País', dest["enderDest"]["xPais"]]
          csv << ['Inscrição Estadual', dest["indIEDest"]]
          csv << ['']
    
          csv << ['Produtos Listados']
          csv << ['Nome', 'NCM', 'CFOP', 'Unidade', 'Quantidade', 'Valor Unitário', 'ICMS', 'IPI']
    
          products = JSON.parse(xml_document.products)
          products.each do |product|
            csv << [
              product['xProd'],
              product['NCM'],
              product['CFOP'],
              product['uCom'],
              product['qCom'],
              product['vUnCom'],
              product['imposto']['ICMS'] || 0,
              product['imposto']['IPI'] || 0
            ]
          end
    
          total_value = products.sum { |p| (p['qCom'].to_f * p['vUnCom'].to_f).round(2) }
          total_icms = products.sum { |p| (p['imposto']['ICMS'].to_f rescue 0.0) }.round(2)
          total_ipi = products.sum { |p| (p['imposto']['IPI'].to_f rescue 0.0) }.round(2)
    
          csv << []
          csv << ['Total Valor dos Produtos', total_value]
          csv << ['Total ICMS', total_icms]
          csv << ['Total IPI', total_ipi]
        end
      end
  end
end
