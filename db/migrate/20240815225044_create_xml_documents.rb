class CreateXmlDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :xml_documents do |t|
      t.string :serie
      t.string :nNF
      t.datetime :dhEmi
      t.jsonb :emit, default: {}
      t.jsonb :dest, default: {}
      t.jsonb :products, default: {}
      t.jsonb :tax, default: {}

      t.timestamps
    end
  end
end
