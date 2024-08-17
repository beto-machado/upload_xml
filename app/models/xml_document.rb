class XmlDocument < ApplicationRecord
  belongs_to :document
  validates :document_id, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "dest", "dhEmi", "document_id", "emit", "nNF", "products", "serie", "tax", "updated_at"]
  end
end
