require 'csv'

RSpec.describe ExportCsvService, type: :service do
  describe '.call' do
    let(:document) { create(:document) }

    let(:xml_document) do
      create(:xml_document, 
        document: document, # Associa o document ao xml_document
        serie: '123',
        nNF: '456',
        dhEmi: Time.current,
        emit: {
          "xNome" => "Empresa Teste",
          "CNPJ" => "12345678000195",
          "fone" => "123456789",
          "enderEmit" => {
            "xLgr" => "Rua Teste",
            "nro" => "123",
            "xBairro" => "Centro",
            "xMun" => "Cidade Teste",
            "UF" => "TS",
            "CEP" => "12345000",
            "xPais" => "Brasil",
            "IE" => "123456789"
          }
        }.to_json,
        dest: {
          "xNome" => "Cliente Teste",
          "CNPJ" => "98765432000123",
          "enderDest" => {
            "xLgr" => "Avenida Teste",
            "xBairro" => "Bairro Teste",
            "xMun" => "Cidade Teste",
            "UF" => "TS",
            "CEP" => "54321000"
          },
          "indIEDest" => "123456789"
        }.to_json,
        products: [
          {
            'xProd' => 'Produto 1',
            'NCM' => '12345678',
            'CFOP' => '5101',
            'uCom' => 'unidade',
            'qCom' => '10',
            'vUnCom' => '100',
            'imposto' => {'ICMS' => '15', 'IPI' => '5'}
          }
        ].to_json
      )
    end

    it 'generates the correct CSV data' do
      csv_data = ExportCsvService.call(xml_document)

      expected_csv = CSV.generate(headers: true) do |csv|
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

      expect(csv_data).to eq(expected_csv)
    end
  end
end
