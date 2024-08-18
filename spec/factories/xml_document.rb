FactoryBot.define do
  factory :xml_document do
    serie { "1" }
    nNF { "01" }
    dhEmi { Time.current }
    emit { { "name" => "Emitente" } }
    dest { { "name" => "Destinatário" } }
    products { { "product" => "Sample Product" } }
    tax { { "amount" => 100.0 } }
  end
end
