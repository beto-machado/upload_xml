class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.string :serie
      t.string :nNF
      t.datetime :dhEmi
      t.text :emit
      t.text :dest
      t.text :products
      t.text :tax

      t.timestamps
    end
  end
end
